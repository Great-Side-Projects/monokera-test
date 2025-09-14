# frozen_string_literal: true
require_relative "../../domain/port/order_publisher"

module Infrastructure
  module Repositories
    class EventPublisher
      def initialize
        @connection = Rails.application.config.bunny_connection
      end
      #include Singleton
      include Domain::Port::OrderPublisher
      def publish_order_created(order_model)
        @connection.start
        channel = @connection.create_channel
        exchange = channel.topic("orders_exchange", durable: true)

        begin
        exchange.publish(
          order_model.to_json,
          routing_key: "order.created"
        )
        @connection.close
        rescue StandardError => e
          Rails.logger.error "Failed to publish order created event: #{e.message}"
          raise e
      end
    end
    end
  end
end
