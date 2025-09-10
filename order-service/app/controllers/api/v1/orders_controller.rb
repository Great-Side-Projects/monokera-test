class Api::V1::OrdersController < ApplicationController

  def create
    # 1. Crear el pedido
    # 2. Llamar a Customer Service para obtener datos
    # 3. Emitir evento a RabbitMQ

    # 1. TODO: Llamar al Customer Service para validar que params[:customer_id] existe.
    #    (Usando Faraday como hablamos antes)

    @order = Order.new(order_params)

    if @order.save
      # 2. TODO: Publicar el evento en RabbitMQ.
      #    (Usando la gema Bunny)

      render json: @order, status: :created
    else
      # Si las validaciones del modelo fallan (ej. falta un campo)
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    # Filtrar por customer_id si se proporciona
    render json: Order.all
  end

  def order_params
    params.require(:order).permit(:customer_id, :product_name, :quantity, :price, :status)
  end
end
