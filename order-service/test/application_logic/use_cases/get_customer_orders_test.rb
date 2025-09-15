# frozen_string_literal: true
require "minitest/autorun"
require "minitest/mock"
require "active_support/testing/declarative"

require_relative "../../../app/application_logic/use_cases/get_customer_orders"
require_relative "../../../app/application_logic/dto/order_response"

class ApplicationLogic::UseCases::GetCustomerOrdersTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative

  def setup
    @mock_repository = Minitest::Mock.new
    @use_case = ApplicationLogic::UseCases::GetCustomerOrders.new(order_repository: @mock_repository)
    @customer_id = "123"

    @sample_orders = [
      {
        customer_id: 123,
        product_name: "Product A",
        quantity: 2,
        price: 50.0,
        total: 100.0,
        status: "completed"
      },
      {
        customer_id: 123,
        product_name: "Product B",
        quantity: 1,
        price: 75.0,
        total: 75.0,
        status: "pending"
      }
    ]
  end

  def teardown
    @mock_repository.verify if @mock_repository
  end

  test "test execute returns order responses when orders found" do
    @mock_repository.expect(:find_by_customer_id, @sample_orders, [@customer_id])

    # Mock OrderResponse creation
    ApplicationLogic::Dto::OrderResponse.stub(:new, ->(order) { order }) do
      result = @use_case.execute(@customer_id)

      assert_equal 2, result.length
      assert_equal @sample_orders, result
    end
  end

  test "test execute returns empty array when no orders found" do
    @mock_repository.expect(:find_by_customer_id, [], [@customer_id])

    ApplicationLogic::Dto::OrderResponse.stub(:new, ->(order) { order }) do
      result = @use_case.execute(@customer_id)

      assert_equal [], result
      assert_instance_of Array, result
    end
  end

  test "test execute calls repository with correct customer id" do
    @mock_repository.expect(:find_by_customer_id, [], [@customer_id])

    ApplicationLogic::Dto::OrderResponse.stub(:new, ->(order) { order }) do
      @use_case.execute(@customer_id)
    end
  end
end
