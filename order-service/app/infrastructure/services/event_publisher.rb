# frozen_string_literal: true
require_relative "../../domain/port/order_publisher"
module Infrastructure
  module Services
    class EventPublisher
      include Domain::Port::OrderPublisher
      def initialize(connection: nil)
        @connection = connection || Rails.application.config.bunny_connection
      end

      def publish_order_created(order_model)
        begin
          @connection.start
          channel = @connection.create_channel
          exchange = channel.topic("orders_exchange", durable: true)

          exchange.publish(
            order_model.to_json,
            routing_key: "order.created"
          )
        rescue => e
          Rails.logger.error "Failed to publish order created event: #{e.message}"
          raise e
        ensure
          # 'ensure' guarantees that the connection is closed,
          # even if an error occurs.
          @connection.close if @connection&.open?
        end
      end
    end
  end
end