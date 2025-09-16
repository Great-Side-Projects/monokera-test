# frozen_string_literal: true
require_relative "../../domain/port/order_publisher"
module Infrastructure
  module Services
    class EventPublisher
      include Domain::Port::OrderPublisher
      def initialize(channel: nil)
        @channel = channel || Rails.application.config.bunny_channel
      end

      def publish_order_created(order_model)
        begin
          exchange = @channel.topic("orders_exchange", durable: true)

          exchange.publish(
            order_model.to_json,
            routing_key: "order.created"
          )
          Rails.logger.info "Published order.created event for customer: #{order_model.customer_id}, order ID: #{order_model.order_id}"
        rescue => e
          Rails.logger.error "Failed to publish order created event: #{e.message}"
          raise e
        end
      end
    end
  end
end