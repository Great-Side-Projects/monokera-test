Rails.application.config.after_initialize do
  # URL AMQP configurada en una variable de entorno
  amqp_url = ENV.fetch("AMQP_URL", "amqp://admin:password@localhost:5672")

  # Inicia una conexión Bunny y la mantiene en la aplicación
  conn = Bunny.new(amqp_url)
  conn.start
  Rails.application.config.bunny_connection = conn
  Rails.application.config.bunny_channel = conn.create_channel

  # cerrar la conexión al terminar la aplicación
  at_exit do
    Rails.logger.info "Closing RabbitMQ connection"
    conn.close if conn && conn.open?
  end
end