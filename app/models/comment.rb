class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :user_id, :course_id, presence: true
  validates :content, length: {maximum: 140}

end
