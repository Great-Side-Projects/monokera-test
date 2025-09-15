# frozen_string_literal: true
require_relative "../../application_logic/dto/order_response"
module ApplicationLogic
  module UseCases
    class GetCustomerOrders
      def initialize(order_repository: Infrastructure::Port::OrderRepository)
        @order_repository = order_repository
      end

      def execute(customer_id)
        orders = @order_repository.find_by_customer_id(customer_id)
        orders.map { |order| ApplicationLogic::Dto::OrderResponse.new(order) }
      end
    end
  end
end