# frozen_string_literal: true
require_relative "../../domain/port/customer_repository"
module Infrastructure
  module Repositories
    include Domain::Port::CustomerRepository
    class ActiveRecordCustomerRepository
      def find_by_customer_id(customer_id)
        Customer.find_by(customer_id: customer_id)
      end
    end
  end
end
