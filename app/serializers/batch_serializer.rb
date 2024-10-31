class BatchSerializer < ActiveModel::Serializer
  attributes :id, :batch_number, :quantity, :price, :expiration_date, :manufacture_date
  belongs_to :product
end