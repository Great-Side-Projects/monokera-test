# frozen_string_literal: true

class EventConsumer
  include Sneakers::Worker
  from_queue "orders", ack: true, durable: true
  def work(message_payload)
    data = JSON.parse(message_payload)
    Rails.logger.info "Received message: #{data}"
    ack!  # confirmamos que fue procesado
  rescue StandardError => e
    Rails.logger.error "Error processing message: #{e.message}"
    # Optionally, reject the message to requeue it or send it to a dead-letter queue
    reject!(:requeue => false)
  end
end
