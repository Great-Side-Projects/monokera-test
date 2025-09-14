# frozen_string_literal: true
require_relative "../../domain/port/order_repository"
require_relative "../../models/order"

module Infrastructure
  module Repositories
    class ActiveRecordOrderRepository
      include Domain::Port::OrderRepository
      def find_by_customer_id(customer_id)
        Order.where(customer_id: customer_id)
      end

      def save(order_model)
        order_record = Order.new(
          customer_id: order_model.customer_id,
          product_name: order_model.product_name,
          quantity: order_model.quantity,
          price: order_model.price,
          status: order_model.status
        )
        order_record.save!
        order_record
      end
    end
  end
end
