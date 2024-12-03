class AddunitToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :unit, :string
  end
end
