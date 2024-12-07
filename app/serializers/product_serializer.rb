# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :product_name, :batch_ids, :category_id, :status, :image_url, :unit, :created_at, :updated_at
  # belongs_to :category
  # has_many :batches, serializer: ProductBatchSerializer

  def batch_ids
    object.batches.pluck(:id)
  end

  def unit
    object.unit || "cái"
  end

  def create_image_url
    return nil unless object.image.attached?

    return object.image.url if active_storage_provider == :cloudinary

    url_for(object.image)
  end

  private

  def active_storage_provider
    ActiveStorage::Blob.service.class.name.demodulize.underscore.to_sym
  end

  def url_for(attachment)
    rails_blob_url(attachment, host: ENV["HOST"] || "http://localhost:#{ENV["PORT"]}")
  end
end
