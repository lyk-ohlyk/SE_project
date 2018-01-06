class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy

  validates :course_name, presence: true
  validates :site_id, length: {is: 6}
  #
  # def new_ass!(assignment)
  #
  # end



end
