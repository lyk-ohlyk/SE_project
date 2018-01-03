class Assignment < ApplicationRecord
  belongs_to :course
  # 用来确定排序：按时间逆序
  default_scope -> { order('created_at DESC') }

  validates :course_id, presence: true
end
