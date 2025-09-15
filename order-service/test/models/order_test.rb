require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "should be valid with all required attributes" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      status: "pending"
    )
    assert order.valid?
  end

  test "should require customer_id" do
    order = Order.new(
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:customer_id], "can't be blank"
  end

  test "should require product_name" do
    order = Order.new(
      customer_id: 123,
      quantity: 2,
      price: 99.99,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:product_name], "can't be blank"
  end

  test "should require quantity" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      price: 99.99,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:quantity], "can't be blank"
  end

  test "should require quantity to be greater than 0" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 0,
      price: 99.99,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:quantity], "must be greater than 0"
  end

  test "should reject negative quantity" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: -1,
      price: 99.99,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:quantity], "must be greater than 0"
  end

  test "should require price" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:price], "can't be blank"
  end

  test "should require price to be greater than 0" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 0,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:price], "must be greater than 0"
  end

  test "should reject negative price" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: -10.50,
      status: "pending"
    )
    assert_not order.valid?
    assert_includes order.errors[:price], "must be greater than 0"
  end

  test "should require status" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99
    )
    assert_not order.valid?
    assert_includes order.errors[:status], "can't be blank"
  end

  test "should accept decimal quantities" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2.5,
      price: 99.99,
      status: "pending"
    )
    assert order.valid?
  end

  test "should accept decimal prices" do
    order = Order.new(
      customer_id: 123,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      status: "pending"
    )
    assert order.valid?
  end
end
