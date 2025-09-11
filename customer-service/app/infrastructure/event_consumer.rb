# frozen_string_literal: true

class EventConsumer
  include Sneakers::Worker
  from_queue "orders", ack: true, durable: true
  def work(message_payload)
    data = JSON.parse(message_payload)
    Rails.logger.info "Received message: #{data}"
    update_customer_order_count(data["customer_id"])
    ack!  # confirmamos que fue procesado
  rescue StandardError => e
    Rails.logger.error "Error processing message: #{e.message}"
    # Optionally, reject the message to requeue it or send it to a dead-letter queue
    reject!(:requeue => false)
  end
  def update_customer_order_count(customer_id)
    Customer.where(customer_id: customer_id).update_all("orders_count = orders_count + 1")
  end
end
