class AddStockToBatches < ActiveRecord::Migration[7.1]
  def change
    add_column :batches, :stock, :integer, default: 0
    add_column :batches, :import_price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
