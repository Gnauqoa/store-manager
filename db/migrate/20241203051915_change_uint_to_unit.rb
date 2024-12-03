class ChangeunitToUnit < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :unit, :unit
  end
end
