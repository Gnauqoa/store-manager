class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :batch_id, :price, :batch, :product ,:quantity, :created_at, :updated_at
end