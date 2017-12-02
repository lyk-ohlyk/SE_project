class StudentId < ApplicationRecord
  validates(:number, presence: true, length: {is: 15})
end
