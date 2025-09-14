# frozen_string_literal: true
require_relative "../../domain/port/order_publisher"

module Infrastructure
  module Repositories
    class EventPublisher
      #include Singleton
      include Domain::Port::OrderPublisher
      def publish_order_created(order)
        connection = Rails.application.config.bunny_connection
        connection.start
        channel = connection.create_channel
        exchange = channel.topic("orders_exchange", durable: true)

        exchange.publish(
          order.to_json,
          routing_key: "order.created"
        )
        connection.close
      end
    end
  end
end
