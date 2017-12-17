# FactoryBot.define do
#   factory :user do
#     name 'Michael Hartl'
#     email 'michael@example.com'
#     student_id '201728001007000'
#     password 'foobar'
#     password_confirmation 'foobar'
#   end
# end

FactoryBot.define do
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
end