# frozen_string_literal: true

class Customer < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_fullname, against: %i[first_name last_name], using: {
    tsearch: { prefix: true }
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :orders
        
  def initialize(*args)
    super(*args)

  end
end
