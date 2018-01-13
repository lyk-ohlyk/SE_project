class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :comments , dependent:  :destroy

  validates :course_name, presence: true
  # validates :site_id, length: {is: 6}
  #
  # def new_ass!(assignment)
  #
  # end



end
