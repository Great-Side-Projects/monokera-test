# frozen_string_literal: true
require_relative "../../application_logic/dto/customer_response"
module ApplicationLogic
  module UseCases
    class GetCustomer
      def initialize(customer_repository: Infrastructure::Port::CustomerRepository)
        @customer_repository = customer_repository
      end
      def execute(customer_id)
        customer = @customer_repository.find_by_customer_id(customer_id)
        ApplicationLogic::Dto::CustomerResponse.new(customer) if customer
      end
    end
  end
end
