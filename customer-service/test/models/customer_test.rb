require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    customer = Customer.new
    assert customer.valid?
  end

  test "should save a customer" do
    customer = Customer.new
    assert customer.save
    assert_not_nil customer.id
  end

  test "should retrieve a customer by id" do
    customer = Customer.create!
    found_customer = Customer.find(customer.id)
    assert_equal customer.id, found_customer.id
  end

  test "should update a customer" do
    customer = Customer.create!
    original_updated_at = customer.updated_at

    travel 1.second do
      customer.touch
      assert_not_equal original_updated_at, customer.updated_at
    end
  end

  test "should delete a customer" do
    customer = Customer.create!
    customer_id = customer.id

    customer.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      Customer.find(customer_id)
    end
  end

  test "should have timestamps" do
    customer = Customer.create!
    assert_not_nil customer.created_at
    assert_not_nil customer.updated_at
  end

  test "should find customer by attributes if they exist" do
    # This test would need actual attributes - adjust based on your schema
    customer = Customer.create!
    found_customer = Customer.find_by(id: customer.id)
    assert_equal customer, found_customer
  end
end