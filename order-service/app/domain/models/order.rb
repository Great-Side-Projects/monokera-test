# frozen_string_literal: true

module Domain
  module Models
    class Order
      attr_reader :customer_id, :product_name, :quantity, :price, :status
      def initialize(customer_id:, product_name:, quantity:, price:, status:)
        @customer_id = customer_id
        @product_name = product_name
        @quantity = quantity
        @price = price
        @status = status
      end
    end
  end
end
