# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Customer seed data 10 entries
10.times do |i|
  Customer.find_or_create_by!(customer_id: "customer@email#{i + 1}.com") do |customer|
    # email is unique in the model customers identifier
    customer.email = "customer@email#{i + 1}.com"
    customer.name = "Customer #{i + 1}"
    customer.address = "Address #{i + 1}"
    customer.orders_count = 1
  end
end

