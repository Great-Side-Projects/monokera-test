class Api::V1::CustomersController < ApplicationController

  def show_by_customer_id
    @customer = Customer.find_by(customer_id: params[:customer_id])
    if @customer .nil?
      render json: { error: 'Customer not found' }, status: :not_found
      return
    end

    render json: @customer, status: :ok
  end

end
