# frozen_string_literal: true

# En Order Service
class CustomerApiService
  include HTTParty
  base_uri ENV.fetch("CUSTOMER_API_URL", "http://localhost:3001")

  def self.find_customer(customer_id)
    get("/api/v1/customers/#{customer_id}")
  end
end
