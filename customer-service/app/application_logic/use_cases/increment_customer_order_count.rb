# frozen_string_literal: true

module ApplicationLogic
  module UseCases
    class IncrementCustomerOrderCount
      def initialize(customer_repository: Infrastructure::Port::CustomerRepository)
        @customer_repository = customer_repository
      end
      def execute(customer_id)
        @customer_repository.increment_customer_order_count(customer_id)
      end
    end
  end
end

