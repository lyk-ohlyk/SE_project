require 'rails_helper'
#
RSpec.describe "CoursePages", type: :request do
  subject { page }

  describe 'infomation page' do
    let(:course) { FactoryBot.create(:course)}
    let!(:c1) { FactoryBot.create(:assignment, course: course, title: "Foo") }
    let!(:c2) { FactoryBot.create(:assignment, course: course, title: "Bar") }

    before { visit course_path(course) }
    it { should have_content(course.course_name) }
    it { should have_title(course.course_name) }
    describe 'assignments' do
      it { should have_content(c1.title) }
      it { should have_content(c2.title) }
      it { should have_content(course.assignments.count) }
    end
  end

end