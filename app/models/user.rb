class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password_digest, presence: true
  validates :password_digest, length: { minimum: 8 }

  validates :username, length: { minimum: 5 }, on: :update
end
