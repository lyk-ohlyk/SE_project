require 'rails_helper'
#
RSpec.describe 'CoursePages', type: :request do
  subject { page }

  describe 'infomation page' do
    let(:course) { FactoryBot.create(:course)}
    let!(:c1) { FactoryBot.create(:assignment, course: course, title: 'Foo') }
    let!(:c2) { FactoryBot.create(:assignment, course: course, title: 'Bar') }

    before { visit course_path(course) }
    it { should have_content(course.course_name) }
    it { should have_title(course.course_name) }
    describe 'assignments' do
      it { should have_content(c1.title) }
      it { should have_content(c2.title) }
      it { should have_content(course.assignments.count) }
    end
  end

  describe 'edit course' do
    let(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin)}
    let(:course) { FactoryBot.create(:course)}
    # describe 'if not admin' do
    #   before do
    #     sign_in user
    #     visit edit_course_path(course)
    #   end
    #   specify { expect(response).to redirect_to(root_path) }
    # end

    describe 'admin can do this' do
      before do
        sign_in admin
        visit edit_course_path(course)
      end
      describe 'page' do
        it { should have_content('修改课程信息') }
        it { should have_title('修改课程信息') }
      end

      describe 'with valid information' do
        let(:new_name) { 'New Course Name' }
        let(:new_course_site) { '123333' }
        before do
          fill_in '课程名称', with: new_name
          fill_in '课程网站', with: new_course_site
          click_button '保存'
        end
        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        specify { expect(course.reload.course_name).to eq new_name }
        specify { expect(course.reload.site_id).to eq new_course_site }
      end

    end
  end # edit course

end