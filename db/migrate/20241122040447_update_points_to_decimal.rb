class UpdatePointsToDecimal < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :points, :decimal, precision: 10, scale: 2
    change_column :point_transactions, :points, :decimal, precision: 10, scale: 2
  end
end
