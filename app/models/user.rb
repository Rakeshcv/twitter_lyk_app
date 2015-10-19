class User < ActiveRecord::Base

  before_save { email.downcase! }

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX, allow_blank: true}, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, presence: true
end