# frozen_string_literal: true
require_relative "../../domain/models/order"
require_relative "../../application_logic/dto/order_response"
module ApplicationLogic
  module UseCases
    class CreateOrder
        def initialize(order_repository:, customer_service:, event_publisher:)
        @order_repository = order_repository
        @customer_service = customer_service
        @event_publisher = event_publisher
      end
      def execute(request)

        # Verificar que el customer existe
        # TODO: Manejar errores de conexión o respuestas inválidas y mapear a errores de aplicación
        begin
          customer = @customer_service.find_customer(request.customer_id)
        rescue StandardError => e
          raise ArgumentError,  "error: Error connecting to Customer service:"
        end

        if customer.code != 200
          raise ArgumentError, "error: Customer not found"
        end
        # Crear entidad de dominio
        # TODO: Usar un factory o constructor de entidad si es necesario

        order = Domain::Models::Order.new(
          customer_id: request.customer_id,
          product_name: request.product_name,
          quantity: request.quantity,
          price: request.price,
          status: "pending" # Estado inicial
        )

        # Persistir
        begin
          ActiveRecord::Base.transaction do
            @saved_order = @order_repository.save(order)
            event_order_created = Struct.new(:order_id, :customer_id).new(@saved_order.id, @saved_order.customer_id)
            # TODO: patron outbox para asegurar la entrega del evento
            @event_publisher.publish_order_created(event_order_created)
            # Publicar evento
            Rails.logger.info "Order created event published for Order ID: #{@saved_order.id} and Customer ID: #{@saved_order.customer_id}"
          end
        rescue StandardError => e
          raise StandardError, "error: Failed to create order"
        end


        # Retornar DTO de respuesta
        ApplicationLogic::Dto::OrderResponse.new(@saved_order)
      end
    end
  end
end