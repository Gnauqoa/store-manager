class PointTransaction < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :order, optional: true

  # Enum for transaction types
  enum transaction_type: { 
    credit: 1,
    debit: 0 
  }

  # Validations
  validates :transaction_type, presence: true
  validates :points, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, length: { maximum: 255 }, allow_nil: true
end
