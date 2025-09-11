class ChageColumnTypeInOrders < ActiveRecord::Migration[8.0]
  def change
    change_column :orders, :customer_id, :string
  end
end
