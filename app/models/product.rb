class Product < ApplicationRecord
  has_many :batches
  belongs_to :category
end
