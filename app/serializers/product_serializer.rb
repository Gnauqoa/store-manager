# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :created_at, :updated_at, :status, :image_url
  belongs_to :category
  has_many :batches, serializer: ProductBatchSerializer

  def image_url

    object.image.attached? ? object.image.url : nil
  end
end
