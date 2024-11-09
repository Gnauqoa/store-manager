class AddProductIdToOrderItem < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :product_id, :integer, null: false
  end
end
