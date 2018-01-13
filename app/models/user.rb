class User < ApplicationRecord
  # has_many :courses
  has_many :microposts, dependent: :destroy

  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id',
           class_name: 'Relationship', # 如果没有类名，rails会寻找这个ReverseRelationship类
           dependent: :destroy
  has_many :followers, through: :reverse_relationships, :source => :follower

  has_many :relatecourses, foreign_key: 'learner_id', dependent: :destroy
  has_many :lessons, :through => :relatecourses, :source => :lesson

  has_many :comments, dependent: :destroy
  #存入数据库之前，把email换成小写的模式
  #作用是防止大小写的重复
  #before_save { self.email = email.downcase }
  before_save { email.downcase! }
  before_create :create_remember_token

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

  # validates :student_id, presence: true,
  #           length: {is: 15}

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
# This is preliminary. See "Following users" for the full implementation.
    Micropost.from_users_followed_by(self)
  end
  def assignments_of_lessons
    Assignment.from_courses_learned_by(self)
  end


  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def learning?(new_lesson)
    relatecourses.find_by(lesson_id: new_lesson.id)
  end
  def learn!(new_lesson)
    relatecourses.create!(lesson_id: new_lesson.id)
  end
  def unlearn!(new_lesson)
    relatecourses.find_by(lesson_id: new_lesson.id).destroy
  end


  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end