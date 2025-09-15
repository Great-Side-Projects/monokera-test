require_relative "../../../infrastructure/repositories/active_record_customer_repository"
require_relative "../../../application_logic/use_cases/get_customer"
class Api::V1::CustomersController < ApplicationController
  before_action :setup_dependencies
  def show_by_customer_id
    @customer = @get_customer.execute(params[:customer_id])
    if @customer .nil?
      render json: { error: 'Customer not found' }, status: :not_found
      return
    end

    render json: @customer, status: :ok
  end

  private

  def setup_dependencies
   @customer_repository = Infrastructure::Repositories::ActiveRecordCustomerRepository.new

   @get_customer = ApplicationLogic::UseCases::GetCustomer.new(
      customer_repository: @customer_repository
    )
  end

end
