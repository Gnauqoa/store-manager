class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :phone, :created_at, :updated_at
end