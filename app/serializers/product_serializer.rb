# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :created_at, :updated_at, :status, :image_url
  belongs_to :category
  has_many :batches, serializer: ProductBatchSerializer

  def image_url
    object.image.attached? ? url_for(object.image) : nil
  end


  private

  def url_for(attachment)
    Rails.application.routes.url_helpers.rails_blob_url(attachment, host: ENV['HOST'] || "http://localhost:#{ENV['PORT']}")
  end
end
