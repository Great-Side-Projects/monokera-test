# frozen_string_literal: true

# En Order Service
class CustomerApiService
  include HTTParty
  base_uri 'http://localhost:3000' # URL del Customer Service

  def self.find_customer(customer_id)
    get("/api/v1/customers/#{customer_id}")
  end
end
