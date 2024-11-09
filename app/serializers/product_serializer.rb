# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :created_at, :updated_at, :status
  belongs_to :category
  has_many :batches
end
