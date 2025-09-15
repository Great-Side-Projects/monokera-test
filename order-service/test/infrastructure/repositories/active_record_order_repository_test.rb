# frozen_string_literal: true
require "minitest/autorun"
require "minitest/mock"
require "test_helper"
require_relative "../../../app/infrastructure/repositories/active_record_order_repository"
require_relative "../../../app/models/order"
require_relative "../../../app/domain/models/order"
require "ostruct"

class Infrastructure::Repositories::ActiveRecordOrderRepositoryTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative

  def setup
    @repository = Infrastructure::Repositories::ActiveRecordOrderRepository.new

    @order_model = Domain::Models::Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      status: "pending"
    )

    @order_record = OpenStruct.new(
      id: 1,
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      status: "pending",
      created_at: Time.now,
      updated_at: Time.now
    )
  end

  test "find_by_customer_id returns orders for given customer" do
    expected_orders = [@order_record]
    Order.stub(:where, expected_orders) do
      result = @repository.find_by_customer_id(123)
      assert_equal expected_orders, result
    end
  end

  test "find_by_customer_id returns empty array when no orders found" do
    Order.stub(:where, []) do
      result = @repository.find_by_customer_id(999)
      assert_equal [], result
    end
  end

  test "save creates new Order record with correct attributes" do
    captured_attributes = nil
    order_instance_mock = Minitest::Mock.new
    order_instance_mock.expect(:save!, true)

    Order.stub(:new, ->(attributes) {
      captured_attributes = attributes
      order_instance_mock
    }) do
      result = @repository.save(@order_model)

      assert_equal 123, captured_attributes[:customer_id]
      assert_equal "Test Product", captured_attributes[:product_name]
      assert_equal 2, captured_attributes[:quantity]
      assert_equal 99.99, captured_attributes[:price]
      assert_equal "pending", captured_attributes[:status]
    end

    order_instance_mock.verify
  end

  test "save calls save! on the created order record" do
    order_instance_mock = Minitest::Mock.new
    order_instance_mock.expect(:save!, true)

    Order.stub(:new, order_instance_mock) do
      @repository.save(@order_model)
    end

    order_instance_mock.verify
  end

  test "save returns the saved order record" do
    order_instance_mock = Minitest::Mock.new
    order_instance_mock.expect(:save!, true)
    order_instance_mock.expect(:==, true, [order_instance_mock])

    Order.stub(:new, order_instance_mock) do
      result = @repository.save(@order_model)
      assert_equal order_instance_mock, result
    end

    order_instance_mock.verify
  end

  test "save maps all order model attributes correctly" do
    order_model_with_all_fields = Domain::Models::Order.new(
      customer_id: 456,
      product_name: "Another Product",
      quantity: 5,
      price: 199.99,
      status: "completed"
    )

    captured_attributes = nil
    order_instance_mock = Minitest::Mock.new
    order_instance_mock.expect(:save!, true)

    Order.stub(:new, ->(attributes) {
      captured_attributes = attributes
      order_instance_mock
    }) do
      @repository.save(order_model_with_all_fields)

      assert_equal 456, captured_attributes[:customer_id]
      assert_equal "Another Product", captured_attributes[:product_name]
      assert_equal 5, captured_attributes[:quantity]
      assert_equal 199.99, captured_attributes[:price]
      assert_equal "completed", captured_attributes[:status]
    end

    order_instance_mock.verify
  end

  test "repository includes OrderRepository port interface" do
    assert_includes @repository.class.included_modules, Domain::Port::OrderRepository
  end
end