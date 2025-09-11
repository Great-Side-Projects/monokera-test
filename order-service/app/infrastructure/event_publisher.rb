# frozen_string_literal: true

class EventPublisher
  include Singleton
  def self.publish_order_created(order)
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
