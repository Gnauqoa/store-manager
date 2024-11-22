class AddDefaultForProductQuantity < ActiveRecord::Migration[7.1]
  def change
    change_column_default :products, :stock_quantity, from: nil, to: 0
    change_column_default :batches, :quantity, from: nil, to: 0
  end
end
