# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Order seed data 20 entries
 20.times do |i|
  Order.find_or_create_by!(
    customer_id: rand(1..10),
    product_name: "Product #{i + 1}",
    quantity: rand(1..5),
    price: (rand * 100).round(2),
    status: ["pending", "shipped", "delivered"].sample
  )
 end

# Add more seed data as needed

