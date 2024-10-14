class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true, index: true # Tham chiếu tới bảng orders
      t.references :batch, foreign_key: true, index: true # Tham chiếu tới bảng batches
      t.integer :quantity

      t.timestamps
    end
  end
end
