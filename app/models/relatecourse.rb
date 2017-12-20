class Relatecourse < ApplicationRecord
  belongs_to :learner, class_name: "User"
  belongs_to :lesson, class_name: 'Course'

  validates :learner_id, presence: true
  validates :lesson_id, presence: true

end
