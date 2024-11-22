# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :product_name, :created_at, :updated_at, :status, :image_url
  belongs_to :category
  has_many :batches, serializer: ProductBatchSerializer

  def image_url
    return nil unless object.image.attached?

    return object.image.url if active_storage_provider == :cloudinary
    
    url_for(object.image)
  end

  private

  def active_storage_provider
    ActiveStorage::Blob.service.class.name.demodulize.underscore.to_sym
  end

  def url_for(attachment)
    rails_blob_url(attachment, host: ENV['HOST'] || "http://localhost:#{ENV['PORT']}")
  end
end
