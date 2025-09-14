# frozen_string_literal: true

module ApplicationLogic
  module Dto
    class OrderResponse
      attr_reader :customer_id, :product_name, :quantity, :price, :status, :created_at, :updated_at

      def initialize(order_entity)
        @customer_id = order_entity.customer_id
        @product_name = order_entity.product_name
        @quantity = order_entity.quantity
        @price = order_entity.price
        @status = order_entity.status
        @created_at = order_entity.created_at
        @updated_at = order_entity.updated_at
      end
    end
  end
end