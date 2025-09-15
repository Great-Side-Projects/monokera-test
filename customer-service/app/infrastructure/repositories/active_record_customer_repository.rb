# frozen_string_literal: true
require_relative "../../domain/port/customer_repository"
module Infrastructure
  module Repositories
    class ActiveRecordCustomerRepository
      include Domain::Port::CustomerRepository
      def find_by_customer_id(customer_id)
        Customer.find_by(customer_id: customer_id)
      end
      def increment_customer_order_count(customer_id)
        Customer.where(customer_id: customer_id).update_all("orders_count = orders_count + 1")
      end
    end
  end
end
