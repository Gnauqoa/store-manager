class ProductBatchSerializer < ActiveModel::Serializer
  attributes :id, :batch_number, :quantity, :stock, :import_price, :price, :expiration_date, :manufacture_date
end