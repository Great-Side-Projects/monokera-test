# frozen_string_literal: true

module ApplicationLogic
  module Dto
    class CreateOrderRequest
      attr_accessor :customer_id, :product_name, :quantity, :price
      def initialize(customer_id:, product_name:, quantity:, price:)
        @customer_id = customer_id
        @product_name = product_name
        @quantity = quantity
        @price = price
      end
    end
  end
end
