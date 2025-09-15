
require "sneakers/runner"
require_relative "../../app/infrastructure/services/event_consumer"
require_relative "../../app/infrastructure/repositories/active_record_customer_repository"
Rails.application.config.after_initialize do

  Thread.new do
    begin
      customer_repository = Infrastructure::Repositories::ActiveRecordCustomerRepository.new
      Infrastructure::Services::EventConsumer.customer_repository = customer_repository
      workers = [Infrastructure::Services::EventConsumer]
      runner = Sneakers::Runner.new(workers)
      runner.run
    rescue => e
      Rails.logger.error "[Sneakers] Error en runner: #{e.message}"
    end
  end
end
