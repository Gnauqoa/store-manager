class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :category, foreign_key: true, index: true # Tham chiếu tới bảng categories
      t.string :product_name
      t.integer :stock_quantity
      t.integer :status

      t.timestamps
    end
  end
end
