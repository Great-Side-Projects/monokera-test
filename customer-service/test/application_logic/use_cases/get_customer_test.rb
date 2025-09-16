# frozen_string_literal: true
require "test_helper"
require "minitest/test"
require 'minitest/autorun'
require_relative '../../../app/application_logic/use_cases/get_customer'
require_relative '../../../app/application_logic/dto/customer_response'

class ApplicationLogic::UseCases::GetCustomerTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative

  def setup
    @repository_mock = Minitest::Mock.new
    @use_case = ApplicationLogic::UseCases::GetCustomer.new(customer_repository: @repository_mock)
  end

  def teardown
    @repository_mock.verify
  end

 test "execute returns customer response when customer exists" do
   customer = Object.new
   response = Object.new

   @repository_mock.expect :find_by_customer_id, customer, [123]

   ApplicationLogic::Dto::CustomerResponse.stub :new, response do
     result = @use_case.execute(123)
     assert_equal response, result
   end
 end

  test "execute returns nil when customer does not exist" do
    @repository_mock.expect :find_by_customer_id, nil, [456]

    result = @use_case.execute(456)

    assert_nil result
  end

  test "execute calls repository with correct customer_id" do
    customer_id = 789
    @repository_mock.expect :find_by_customer_id, nil, [customer_id]

    @use_case.execute(customer_id)
  end

  test "execute creates customer response with found customer" do
    customer = Object.new
    created_with = nil

    @repository_mock.expect :find_by_customer_id, customer, [123]

    ApplicationLogic::Dto::CustomerResponse.stub :new, ->(cust) { created_with = cust; Object.new } do
      @use_case.execute(123)
    end

    assert_same customer, created_with
  end
end