class User < ApplicationRecord
  # has_many Course

  #存入数据库之前，把email换成小写的模式
  #作用是防止大小写的重复
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password
  validates :password, length: { minimum: 6 }
end


#C:\RailsInstaller\Ruby2.3.3\lib\ruby\gems\2.3.0\gems\bcrypt-3.1.11-x86-mingw32\ext\mri