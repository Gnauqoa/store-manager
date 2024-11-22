class CreatePointTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :point_transactions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :order, foreign_key: true # Nullable, for cases not tied to an order
      t.integer :transaction_type, null: false # 'earn' or 'redeem'
      t.integer :points, null: false
      t.string :description # Optional note about the transaction
      t.timestamps
    end
  end
end
