# require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 student_id:"132413241234123",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      student_id = "132413241234123"
      User.create!(name: name,
                   email: email,
                   student_id: student_id,
                   password: password,
                   password_confirmation: password)
    end
  end
end