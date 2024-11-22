class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :phone, :points, :created_at, :updated_at
end