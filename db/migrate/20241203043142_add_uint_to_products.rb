class AddUintToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :uint, :string
  end
end
