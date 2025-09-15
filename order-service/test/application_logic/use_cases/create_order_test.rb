# frozen_string_literal: true
require "minitest/autorun"
require "minitest/mock"
require "test_helper"
require_relative "../../../app/application_logic/use_cases/create_order"
require_relative "../../../app/domain/models/order"
require_relative "../../../app/application_logic/dto/order_response"
require "ostruct"

class ApplicationLogic::UseCases::CreateOrderTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative

  def setup
    @order_repository_mock = Minitest::Mock.new
    @customer_service_mock = Minitest::Mock.new
    @event_publisher_mock = Minitest::Mock.new

    @use_case = ApplicationLogic::UseCases::CreateOrder.new(
      order_repository: @order_repository_mock,
      customer_service: @customer_service_mock,
      event_publisher: @event_publisher_mock
    )

    @valid_request = OpenStruct.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99
    )

    @saved_order = OpenStruct.new(
      id: 1,
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      status: "pending",
      created_at: Time.now,
      updated_at: Time.now
    )

    @customer_response = OpenStruct.new(code: 200)
  end

  def teardown
    [@order_repository_mock, @customer_service_mock, @event_publisher_mock].each do |mock|
      mock.verify rescue nil
    end
  end

  test "successfully creates order when customer exists" do
    @customer_service_mock.expect(:find_customer, @customer_response, [123])
    @order_repository_mock.expect(:save, @saved_order, [Domain::Models::Order])
    @event_publisher_mock.expect(:publish_order_created, nil, [Object])

    ActiveRecord::Base.stub(:transaction, ->(opts = {}, &block) { block.call }) do
      Rails.logger.stub(:info, nil) do
        result = @use_case.execute(@valid_request)
        assert_instance_of ApplicationLogic::Dto::OrderResponse, result
      end
    end
  end

  test "raises ArgumentError when customer service throws StandardError" do
    @customer_service_mock.expect(:find_customer, proc { raise StandardError, "Connection failed" })

    error = assert_raises(ArgumentError) do
      @use_case.execute(@valid_request)
    end

    assert_equal "error: Error connecting to Customer service:", error.message
  end

  test "raises ArgumentError when customer service throws specific exception" do
    @customer_service_mock.expect(:find_customer, proc { raise Net::TimeoutError })

    error = assert_raises(ArgumentError) do
      @use_case.execute(@valid_request)
    end

    assert_equal "error: Error connecting to Customer service:", error.message
  end

  test "raises ArgumentError when customer is not found" do
    customer_not_found_response = OpenStruct.new(code: 404)
    @customer_service_mock.expect(:find_customer, customer_not_found_response, [123])

    error = assert_raises(ArgumentError) do
      @use_case.execute(@valid_request)
    end

    assert_equal "error: Customer not found", error.message
  end

  test "raises ArgumentError when customer service returns error code" do
    customer_error_response = OpenStruct.new(code: 500)
    @customer_service_mock.expect(:find_customer, customer_error_response, [123])

    error = assert_raises(ArgumentError) do
      @use_case.execute(@valid_request)
    end

    assert_equal "error: Customer not found", error.message
  end

  test "creates order entity with correct attributes" do
    @customer_service_mock.expect(:find_customer, @customer_response, [123])

    captured_order = nil
    @order_repository_mock.expect(:save, @saved_order) do |order|
      captured_order = order
      @saved_order
    end

    @event_publisher_mock.expect(:publish_order_created, nil, [Object])

    ActiveRecord::Base.stub(:transaction, ->(opts = {}, &block) { block.call }) do
      Rails.logger.stub(:info, nil) do
        @use_case.execute(@valid_request)

        assert_equal 123, captured_order.customer_id
        assert_equal "Test Product", captured_order.product_name
        assert_equal 2, captured_order.quantity
        assert_equal 99.99, captured_order.price
        assert_equal "pending", captured_order.status
      end
    end
  end

test "publishes order created event with correct data" do
  @customer_service_mock.expect(:find_customer, @customer_response, [123])
  @order_repository_mock.expect(:save, @saved_order, [Domain::Models::Order])

  captured_event = nil
  @event_publisher_mock.expect(:publish_order_created, nil) do |event|
    captured_event = event
  end

  ActiveRecord::Base.stub(:transaction, ->(opts = {}, &block) { block.call }) do
    Rails.logger.stub(:info, nil) do
      result = @use_case.execute(@valid_request)

      # Assert the captured event has correct data
      refute_nil captured_event, "Event should have been captured"
      assert_equal 1, captured_event.order_id
      assert_equal 123, captured_event.customer_id
      assert_instance_of ApplicationLogic::Dto::OrderResponse, result
    end
  end
end


  test "logs order creation event" do
    @customer_service_mock.expect(:find_customer, @customer_response, [123])
    @order_repository_mock.expect(:save, @saved_order, [Domain::Models::Order])
    @event_publisher_mock.expect(:publish_order_created, nil, [Object])

    logged_message = nil
    ActiveRecord::Base.stub(:transaction, ->(opts = {}, &block) { block.call }) do
      Rails.logger.stub(:info, ->(msg) { logged_message = msg }) do
        @use_case.execute(@valid_request)

        expected_message = "Order created event published for Order ID: 1 and Customer ID: 123"
        assert_equal expected_message, logged_message
      end
    end
  end

  test "raises StandardError when repository save fails" do
    @customer_service_mock.expect(:find_customer, @customer_response, [123])
    @order_repository_mock.expect(:save, proc { raise ActiveRecord::RecordInvalid })

    ActiveRecord::Base.stub(:transaction, ->(opts = {}, &block) { block.call }) do
      error = assert_raises(StandardError) do
        @use_case.execute(@valid_request)
      end

      assert_equal "error: Failed to create order", error.message
    end
  end

  test "raises StandardError when event publishing fails" do
    @customer_service_mock.expect(:find_customer, @customer_response, [123])
    @order_repository_mock.expect(:save, @saved_order, [Domain::Models::Order])
    @event_publisher_mock.expect(:publish_order_created, proc { raise StandardError, "Event service down" })

    ActiveRecord::Base.stub(:transaction, ->(opts = {}, &block) { block.call }) do
      Rails.logger.stub(:info, nil) do
        error = assert_raises(StandardError) do
          @use_case.execute(@valid_request)
        end

        assert_equal "error: Failed to create order", error.message
      end
    end
  end

  test "handles different customer service response codes" do
    [401, 403, 404, 500, 503].each do |error_code|
      order_repository_mock = Minitest::Mock.new
      customer_service_mock = Minitest::Mock.new
      event_publisher_mock = Minitest::Mock.new

      use_case = ApplicationLogic::UseCases::CreateOrder.new(
        order_repository: order_repository_mock,
        customer_service: customer_service_mock,
        event_publisher: event_publisher_mock
      )

      error_response = OpenStruct.new(code: error_code)
      customer_service_mock.expect(:find_customer, error_response, [123])

      error = assert_raises(ArgumentError) do
        use_case.execute(@valid_request)
      end

      assert_equal "error: Customer not found", error.message
      customer_service_mock.verify
    end
  end
end