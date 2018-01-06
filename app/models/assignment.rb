class Assignment < ApplicationRecord
  belongs_to :course
  # 用来确定排序：按时间逆序
  default_scope -> { order('created_at DESC') }

  validates :course_id, presence: true

  def self.from_courses_learned_by(user)
    courses_ids = 'SELECT lesson_id FROM relatecourses WHERE learner_id = :user_id'
    where("course_id IN (#{courses_ids})", user_id: user.id)
  end
end
