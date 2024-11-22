class Order < ApplicationRecord
  has_many :order_items
  belongs_to :customer
  belongs_to :created_by, class_name: 'User'

  enum status: {
    pending: 0,
    completed: 1,
    cancelled: 2
  }
end
