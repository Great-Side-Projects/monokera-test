require "sneakers"

amqp_url = ENV.fetch("AMQP_URL", "amqp://admin:password@localhost:5672")

Sneakers.configure(
  amqp: amqp_url,
  workers: 1,  # cantidad de workers internos
  threads: 1,  # cantidad de threads por worker
  prefetch: 1,
  log: "log/sneakers.log",
  logger: Rails.logger
)

Sneakers.logger.level = Logger::DEBUG

