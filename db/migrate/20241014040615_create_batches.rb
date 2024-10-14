class CreateBatches < ActiveRecord::Migration[7.1]
  def change
    create_table :batches do |t|
      t.references :product, foreign_key: true, index: true # Tham chiếu tới bảng products
      t.string :batch_number
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2 # Giới hạn độ chính xác và số chữ số sau dấu thập phân
      t.timestamp :expiration_date
      t.timestamp :manufacture_date

      t.timestamps
    end
  end
end
