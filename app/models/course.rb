class Course < ApplicationRecord
  validates :course_name, presence: true
end
