# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :birth, :email, :role, :first_name, :last_name, :created_at, :updated_at
end