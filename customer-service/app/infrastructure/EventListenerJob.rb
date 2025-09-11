# frozen_string_literal: true
class EventListenerJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting Event Listener Job..."
    EventConsumer.start_listening
  rescue => e
    Rails.logger.error "Event Listener Job failed: #{e.message}"
    # Reencolar el job si falla
    retry_job(wait: 30.seconds)
  end
end