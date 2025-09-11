class AddIndexToCustomerId < ActiveRecord::Migration[8.0]
  def change
    add_index :orders, :customer_id
  end
end
