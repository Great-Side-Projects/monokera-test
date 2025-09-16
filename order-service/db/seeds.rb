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

ActiveRecord::Base.connection.execute("TRUNCATE TABLE orders RESTART IDENTITY CASCADE;")

10.times do |i|
 Order.find_or_create_by!(id: i + 1) do |order|
   order.customer_id = "customer@email#{i + 1}.com"
   order.product_name = "Product #{i + 1}"
   order.quantity = rand(1..5)
   order.price = (rand * 100).round(2)
   order.status = %w[pending shipped delivered].sample
 end
end

ActiveRecord::Base.connection.reset_pk_sequence!('orders')
# Add more seed data as needed

