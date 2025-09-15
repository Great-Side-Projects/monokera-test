# frozen_string_literal: true

module ApplicationLogic
  module Dto
    class CustomerResponse
      attr_reader :customer_id, :customer_name, :address, :orders_count, :created_at, :updated_at
      def initialize(customer_entity)
        @customer_id = customer_entity.customer_id
        @customer_name = customer_entity.customer_name
        @address = customer_entity.address
        @orders_counts = customer_entity.orders_count
        @created_at = customer_entity.created_at
        @updated_at = customer_entity.updated_at
      end
    end
  end
end
