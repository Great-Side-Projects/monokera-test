# frozen_string_literal: true

require "test_helper"
require "minitest/autorun"
require_relative "../../../app/infrastructure/services/customer_api_service"

module Infrastructure
  module Services
    class CustomerApiServiceTest < Minitest::Test
      extend ActiveSupport::Testing::Declarative
      def setup
        @service = CustomerApiService.new
      end

      def test_initialize_sets_default_base_uri_when_env_not_set
        ENV.delete("CUSTOMER_API_URL")
        service = CustomerApiService.new

        # We can't directly access @base_uri, but we can verify through behavior
        assert service.instance_variable_get(:@base_uri) == "http://localhost:3000"
      end

      test "test initialize uses env variable when set" do
        ENV["CUSTOMER_API_URL"] = "https://api.example.com"
        service = CustomerApiService.new

        assert service.instance_variable_get(:@base_uri) == "https://api.example.com"

        # Clean up
        ENV.delete("CUSTOMER_API_URL")
      end

      test "test find customer makes correct http request" do
        customer_id = 123
        expected_url = "http://localhost:3000/api/v1/customers/123"
        mock_response = { "id" => 123, "name" => "John Doe", "email" => "john@example.com" }
        actual_url = nil

        HTTParty.stub(:get, ->(url) {
          actual_url = url
          mock_response
        }) do
          @service.find_customer(customer_id)
          assert_equal expected_url, actual_url
        end
      end

      test "test find customer returns response" do
        customer_id = 456
        mock_response = { "id" => 456, "name" => "Jane Smith", "email" => "jane@example.com" }

        HTTParty.stub(:get, mock_response) do
          result = @service.find_customer(customer_id)
          assert_equal mock_response, result
        end
      end

     test "test find customer uses custom_base uri from env" do
        ENV["CUSTOMER_API_URL"] = "https://custom.api.com"
        service = CustomerApiService.new
        customer_id = 789
        expected_url = "https://custom.api.com/api/v1/customers/789"
        mock_response = { "id" => 789, "name" => "Bob Wilson" }
        actual_url = nil

        HTTParty.stub(:get, ->(url) {
          actual_url = url
          mock_response
        }) do
          service.find_customer(customer_id)
          assert_equal expected_url, actual_url
        end

        # Clean up
        ENV.delete("CUSTOMER_API_URL")
      end

     test "test find customer handles string customer_id" do
        customer_id = "999"
        expected_url = "http://localhost:3000/api/v1/customers/999"
        mock_response = { "id" => 999, "name" => "Alice Cooper" }
        actual_url = nil

        HTTParty.stub(:get, ->(url) {
          actual_url = url
          mock_response
        }) do
          result = @service.find_customer(customer_id)
          assert_equal expected_url, actual_url
          assert_equal mock_response, result
        end
      end
    end
  end
end