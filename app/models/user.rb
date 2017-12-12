class User < ApplicationRecord
  # has_many Course

  #存入数据库之前，把email换成小写的模式
  #作用是防止大小写的重复
  #before_save { self.email = email.downcase }
  before_save { email.downcase! }

  validates :name, presence: true, length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #正则表达的解释：
  # \A为匹配字符串的开头，\w为匹配英文字母和数字，+号表示至少一个“\w”；
  # \-匹配了“-”号，“.”符号保证了"."不会直接连接"@"，这样的邮箱地址实例我也没见过
  # [a-z\d\-.]+就是指至少1个的字母或数字或("-"加上另一个字符)
  # (\.[a-z]+)*，就是说0次以上("*"的作用)括号里面的内容，这句可以保证不会出现".."的情况
  # \.[a-z]+就简单了，就是匹配".com",".cn"等这部分，\z表示匹配字符串结尾。
  # 最后的i为正则表达式的选项，表示“忽略英文字母大小写”


  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}

  validates :student_id, presence: true,
            length: {is: 15}

  has_secure_password
  validates :password, length: { minimum: 6 }

end


#C:\RailsInstaller\Ruby2.3.3\lib\ruby\gems\2.3.0\gems\bcrypt-3.1.11-x86-mingw32\ext\mri