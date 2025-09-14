# frozen_string_literal: true
require "httparty"
require_relative "../../domain/port/customer_service"
module Infrastructure
  module Repositories
    include Domain::Port::CustomerService
    class CustomerApiService
      def initialize
        @base_uri = ENV.fetch("CUSTOMER_API_URL", "http://localhost:3000")
      end
      def find_customer(customer_id)
        HTTParty.get(@base_uri+"/api/v1/customers/#{customer_id}")
      end
    end
  end
end
