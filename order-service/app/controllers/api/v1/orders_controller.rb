class Api::V1::OrdersController < ApplicationController

  def create
    begin
    response = CustomerApiService.find_customer(order_params[:customer_id])
    rescue StandardError => e
      render json: { error: "Error connecting to Customer service: #{e.message}" }, status: :service_unavailable
      return
    end
    if response.code != 200
      render json: { error: "Customer not found" }, status: :unprocessable_entity
      return
    end

    @order = Order.new(order_params)

    ActiveRecord::Base.transaction do
    if @order.save
      # nuevo objeto para publicar el evento con los datos necesarios
      event_order_created = Struct.new(:order_id, :customer_id).new(@order.id, @order.customer_id)
      EventPublisher.publish_order_created(event_order_created)
      # si el evento no se logro publicar, la transaccion se revierte
      #raise ActiveRecord::Rollback unless EventPublisher.publish_order_created(@order)
      render json: @order, status: :created
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
    end
  end

  def show_by_customer_id
    @order = Order.where(customer_id: params[:customer_id])
    if @order.nil?
      render json: { error: 'Order not found' }, status: :not_found
      return
    end

    render json: @order
  end

  def order_params
    params.require(:order).permit(:customer_id, :product_name, :quantity, :price, :status)
  end
end
