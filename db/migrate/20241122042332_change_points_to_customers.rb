class ChangePointsToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :points, :decimal, precision: 10, scale: 2, default: 0.0
    remove_column :users, :points
  end
end
