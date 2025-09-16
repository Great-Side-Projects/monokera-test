require "test_helper"
require "minitest/mock"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @customer = customers(:one)
  end

  test "should get customer when customer exists" do
    get "/api/v1/customers/#{@customer.customer_id}"

    assert_response :ok
    json_response = JSON.parse(response.body)
    assert_equal @customer.customer_id, json_response['customer_id']
  end

  test "should return not found when customer does not exist" do
    get "/api/v1/customers/99999"

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal 'Customer not found', json_response['error']
  end

  test "should setup dependencies before action" do
    get "/api/v1/customers/#{@customer.customer_id}"

    # This test ensures the before_action callback works
    assert_response :success
  end

  test "should handle invalid customer_id parameter" do
    get "/api/v1/customers/invalid_id"

    assert_response :not_found
  end

  test "should return json content type" do
    get "/api/v1/customers/#{@customer.customer_id}"

    assert_equal 'application/json; charset=utf-8', response.content_type
  end
end