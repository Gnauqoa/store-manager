class PointTransaction < ApplicationRecord
  # Associations
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :order, optional: true

  # Enum for transaction types
  enum transaction_type: { 
    credit: 1,
    debit: 0 
  }
end
