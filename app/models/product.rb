class Product < ApplicationRecord
  has_many :batches
  belongs_to :category

  enum status: { 
    active: 1, 
    inactive: 0 
  }

  has_one_attached :image
end
