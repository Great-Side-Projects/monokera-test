# frozen_string_literal: true
require "test_helper"
require "minitest/autorun"
require "minitest/mock"
require "active_support/testing/declarative"
require_relative "../../../app/infrastructure/repositories/active_record_customer_repository"
require_relative "../../../app/models/customer"


class Infrastructure::Repositories::ActiveRecordCustomerRepositoryTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative

  def setup
    @repository = Infrastructure::Repositories::ActiveRecordCustomerRepository.new
  end

  test "find_by_customer_id when customer exists" do
    customer = Object.new
    find_by_called = false

    Customer.stub :find_by, ->(args) { find_by_called = true; customer } do
      result = @repository.find_by_customer_id(123)
      assert_same customer, result
    end

    assert find_by_called
  end


  test "find_by_customer_id when customer does not exist" do
    Customer.stub :find_by, nil do
      result = @repository.find_by_customer_id(999)
      assert_nil result
    end
  end

  test "increment_customer_order_count updates orders_count" do
    relation_mock = Minitest::Mock.new
    relation_mock.expect :update_all, 1, ["orders_count = orders_count + 1"]

    Customer.stub :where, relation_mock do
      result = @repository.increment_customer_order_count(123)
      assert_equal 1, result
    end

    relation_mock.verify
  end

 test "increment_customer_order_count calls where with correct params" do
    relation_mock = Minitest::Mock.new
    relation_mock.expect :update_all, 1, ["orders_count = orders_count + 1"]

    called_with = nil

    Customer.stub :where, ->(args) { called_with = args; relation_mock } do
      @repository.increment_customer_order_count(789)
    end

    assert_equal({ customer_id: 789 }, called_with)
    relation_mock.verify
  end

  test "repository includes customer repository port" do
    assert_includes @repository.class.included_modules, Domain::Port::CustomerRepository
  end
end