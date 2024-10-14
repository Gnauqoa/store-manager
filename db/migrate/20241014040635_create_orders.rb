class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, foreign_key: true, index: true # Tham chiếu tới bảng customers
      t.decimal :total_amount, precision: 10, scale: 2
      t.timestamp :order_date

      t.timestamps
    end
  end
end
