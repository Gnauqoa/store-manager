class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :status
      t.timestamp :birth
      t.string :phone

      t.string "encrypted_password", default: "", null: false
      ## Recoverable
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at", precision: nil
      ## Rememberable
      t.datetime "remember_created_at", precision: nil
      ## Trackable
      t.integer "sign_in_count"
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"

      t.timestamps # This automatically creates 'created_at' and 'updated_at'
    end
  end
end
