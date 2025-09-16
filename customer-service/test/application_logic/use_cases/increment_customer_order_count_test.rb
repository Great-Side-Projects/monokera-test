# frozen_string_literal: true

require "test_helper"
require "minitest/test"
require 'minitest/autorun'
require_relative '../../../app/application_logic/use_cases/increment_customer_order_count'


class ApplicationLogic::UseCases::IncrementCustomerOrderCountTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative
  def setup
    @repository_mock = Minitest::Mock.new
    @use_case = ApplicationLogic::UseCases::IncrementCustomerOrderCount.new(customer_repository: @repository_mock)
  end

  def teardown
    @repository_mock.verify
  end

  test "execute calls repository increment_customer_order_count with correct customer_id" do
    customer_id = 123
    @repository_mock.expect :increment_customer_order_count, nil, [customer_id]

    @use_case.execute(customer_id)
  end

  test "execute returns repository result" do
    customer_id = 456
    expected_result = 1
    @repository_mock.expect :increment_customer_order_count, expected_result, [customer_id]

    result = @use_case.execute(customer_id)

    assert_equal expected_result, result
  end

  test "execute handles different customer_id types" do
    string_customer_id = "789"
    @repository_mock.expect :increment_customer_order_count, nil, [string_customer_id]

    @use_case.execute(string_customer_id)
  end

end
