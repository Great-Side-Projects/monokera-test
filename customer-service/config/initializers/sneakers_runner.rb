
require "sneakers/runner"

Rails.application.config.after_initialize do
  Thread.new do
    begin
      workers = [ EventConsumer ] # aquí agregas tus workers
      runner = Sneakers::Runner.new(workers)
      runner.run
    rescue => e
      Rails.logger.error "[Sneakers] Error en runner: #{e.message}"
    end
  end
end
