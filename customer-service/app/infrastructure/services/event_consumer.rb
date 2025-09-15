# frozen_string_literal: true
require_relative "../../domain/port/customer_repository"
module Infrastructure
  module Services
    class EventConsumer
      # TODO : inyectar mybackgroundjob
      include Sneakers::Worker
      # "class instance variable"
      class << self
        attr_accessor :customer_repository
      end
      # TODO : inyectar mybackgroundjob
      from_queue "orders_created",
                 ack: true,
                 durable: true,
                 exchange: "orders_exchange",
                 exchange_type: :topic,
                 routing_key: "order.created",
                 arguments: {
                   "x-dead-letter-exchange" => "DLX_orders_created_exchange",
                   "x-dead-letter-routing-key" => "order.created"
                 }

      def work(message_payload)
        data = JSON.parse(message_payload)
        Rails.logger.info "Received message: #{data}"
        # TODO: injectar repositorio
        self.class.customer_repository.increment_customer_order_count(data["customer_id"])
        #update_customer_order_count(data["customer_id"])
        ack!  # confirmamos que fue procesado
      rescue StandardError => e
        Rails.logger.error "Error processing message: #{e.message}"
        reject! # send it to a dead-letter queue
      end
      #def update_customer_order_count(customer_id)
      #  Customer.where(customer_id: customer_id).update_all("orders_count = orders_count + 1")
      #end
    end
  end
end
