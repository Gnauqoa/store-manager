# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total_amount, :order_date, :status, :created_at, :updated_at
  has_many :order_items
  belongs_to :customer
end
