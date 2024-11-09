class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :batch_id, :price, :quantity, :created_at, :updated_at

  # Bao gồm thông tin về batch trong order_item
  belongs_to :batch
end