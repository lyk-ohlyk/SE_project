FactoryBot.define do
  factory :user do
    name 'Michael Hartl'
    email 'michael@example.com'
    student_id '201728001007000'
    password 'foobar'
    password_confirmation 'foobar'
  end
end