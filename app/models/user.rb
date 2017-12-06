class User < ApplicationRecord
  # has_many Course

  validates :name, presence: true, length: {maximum: 30}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: true

  before_save { self.email = email.downcase }


end
