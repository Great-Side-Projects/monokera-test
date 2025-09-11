Rails.application.config.after_initialize do
  # Asegúrate de tener tu URL AMQP configurada en una variable de entorno
  amqp_url = ENV.fetch("AMQP_URL", "amqp://admin:password@localhost:5672")

  # Inicia una conexión Bunny y la mantiene en la aplicación
  conn = Bunny.new(amqp_url)
  conn.start
  Rails.application.config.bunny_connection = conn

  # Opcional: crear un canal y una cola para usar en tu aplicación
  #channel = conn.create_channel
  #Rails.application.config.bunny_channel = channel
  #Rails.application.config.bunny_queue = channel.queue("orders", auto_delete: true)

  # Asegúrate de cerrar la conexión al terminar la aplicación
  at_exit do
    conn.close if conn && conn.open?
  end
end