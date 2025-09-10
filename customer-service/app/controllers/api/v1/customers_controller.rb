class Api::V1::CustomersController < ApplicationController

  def show
    @customer = Customer.find(params[:id])
    render json: @customer, status: :ok
  rescue ActiveRecord::RecordNotFound
    # Si .find falla porque el ID no existe, entra aquí
    render json: { error: 'Customer not found' }, status: :not_found
  end

end
