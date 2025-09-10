class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.string :product_name
      t.integer :quantity
      t.decimal :price
      t.string :status

      t.timestamps
    end
  end
end
