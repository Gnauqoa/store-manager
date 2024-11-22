# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_username, against: [:username]
  pg_search_scope :search_by_fullname, against: %i[first_name last_name], using: {
    tsearch: { prefix: true }
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :omniauthable, :trackable

  validates_format_of :email, with: Devise.email_regexp, if: -> { email.present? }
  validates_format_of :username, with: /\A[\w\d_.]*\z/i, if: -> { username.present? }

  enum role: { 
    employee: 0,
    admin: 1,
  }

  has_many :orders, foreign_key: :customer_id, dependent: :destroy
  has_many :created_orders, class_name: 'Order', foreign_key: :created_by, dependent: :nullify
  has_many :point_transactions, foreign_key: :customer_id, dependent: :destroy

  def initialize(*args)
    super(*args)
    self.username = SecureRandom.hex[0..19] unless username
  end

  def self.from_omniauth(auth)
    username = auth.info.nickname || auth.info.email&.split('@')&.first
    if auth.info.email
      where(email: auth.info.email).first_or_create! do |user|
        user.email = auth.info.email
        user.username = username
        user.password ||= Devise.friendly_token[0, 20]
      end
    else
      where(username:).first_or_create! do |user|
        user.email = auth.info.email
        user.username = username
        user.password ||= Devise.friendly_token[0, 20]
      end
    end
  end
  def notifications 
    Notification.where(:user_id => self.id)
  end
  def fullname
    "#{first_name} #{last_name}"
  end
end
