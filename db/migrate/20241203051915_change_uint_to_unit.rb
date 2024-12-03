class ChangeUintToUnit < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :uint, :unit
  end
end
