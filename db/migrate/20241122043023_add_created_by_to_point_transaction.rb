class AddCreatedByToPointTransaction < ActiveRecord::Migration[7.1]
  def change
    add_reference :point_transactions, :created_by, foreign_key: { to_table: :users }
  end
end
