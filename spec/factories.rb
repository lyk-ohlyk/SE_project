# FactoryBot.define do
#   factory :relatecourse do
#     learner_id 1
#     lesson_id 1
#   end
#   factory :relationship do
#     follower_id 1
#     followed_id 1
#   end
#   factory :micropost do
#     content "MyString"
#     user_id 1
#   end
#   factory :user do
#     name 'Michael Hartl'
#     email 'michael@example.com'
#     student_id '201728001007000'
#     password 'foobar'
#     password_confirmation 'foobar'
#   end
# end

FactoryBot.define do
  factory :relatecourse do
    learner_id 1
    lesson_id 1
  end
  factory :relationship do
    follower_id 1
    followed_id 1
  end
  # factory :micropost do
  #   content "MyString"
  #   user_id 1
  # end
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    student_id "asdfasdfasdfasd"
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  factory :course do
    course_code 'test1'
    course_name 'test2'
    course_time 'test3'
    score 'test4'
    exam_date 'test5'
    exam_hour 'test6'
    exam_place 'test7'
  end

end