# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :total_amount, :order_date, :created_at, :updated_at

  # Bao gồm thông tin chi tiết của các items trong order
  has_many :order_items

  # Định nghĩa cách hiển thị của user trong order
  belongs_to :user
end
