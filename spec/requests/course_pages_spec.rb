# require 'rails_helper'
#
# RSpec.describe "CoursePages", type: :request do
#   subject { page }
#
#   let(:user) { FactoryBot.create(:user) }
#   before { sign_in user }
#   describe 'user should be able to view courses' do
#     before { visit root_path }
#
#     describe 'click course button' do
#       before { click_button 'Courses' }
#       it {should have_content('课程名')}
#
#       # describe 'user can add courses' do
#       #   expect {click_link('添加', match: :first)}.to change(Course, :count).by(1)
#       # end
#     end
#   end
#
#   describe 'user can delete his courses' do
#     before { visit root_path }
#     it 'should remove a course' do
#       expect { click_link 'remove' }.to change(Course, :count).by(-1)
#     end
#   end
#
# end
