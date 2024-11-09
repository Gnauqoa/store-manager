class ProductBatchSerializer < ActiveModel::Serializer
  attributes :id, :batch_number, :quantity, :price, :expiration_date, :manufacture_date
end