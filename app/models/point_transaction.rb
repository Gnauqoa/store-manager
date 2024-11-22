class PointTransaction < ApplicationRecord
  # Associations
  belongs_to :customer
  belongs_to :order, optional: true
  belongs_to :created_by, class_name: 'User', optional: true

  # Enum for transaction types
  enum transaction_type: { 
    credit: 1,
    debit: 0 
  }
end
