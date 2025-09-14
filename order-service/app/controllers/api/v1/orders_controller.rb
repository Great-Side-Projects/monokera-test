require_relative "../../../infrastructure/repositories/active_record_order_repository"
require_relative "../../../infrastructure/services/customer_api_service"
require_relative "../../../infrastructure/services/event_publisher"
require_relative "../../../application_logic/use_cases/create_order"
require_relative "../../../application_logic/use_cases/get_customer_orders"
require_relative "../../../application_logic/dto/create_order_request"

class Api::V1::OrdersController < ApplicationController
  before_action :setup_dependencies
  def create

    request = ApplicationLogic::Dto::CreateOrderRequest.new(
      customer_id: params[:customer_id],
      product_name: params[:product_name],
      quantity: params[:quantity],
      price: params[:price]
    )

    response = @create_order.execute(request)
    render json: response, status: :created
  end

  def show_by_customer_id
    @order = @get_customer_orders.execute(params[:customer_id])
    if @order.empty?
      render json: { error: "Orders not found" }, status: :not_found
      return
    end

    render json: @order
  end

  def order_params
    params.require(:order).permit(:customer_id, :product_name, :quantity, :price, :status)
  end

  private
  def setup_dependencies
    @order_repository =  Infrastructure::Repositories::ActiveRecordOrderRepository.new
    @customer_service = Infrastructure::Repositories::CustomerApiService.new
    @event_publisher = Infrastructure::Repositories::EventPublisher.new

    @create_order = ApplicationLogic::UseCases::CreateOrder.new(
      order_repository: @order_repository,
      customer_service: @customer_service,
      event_publisher: @event_publisher
    )

    @get_customer_orders = ApplicationLogic::UseCases::GetCustomerOrders.new(
      order_repository: @order_repository
    )
  end
end


