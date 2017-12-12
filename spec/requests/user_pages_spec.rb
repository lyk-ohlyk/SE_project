require 'rails_helper'

RSpec.describe 'UserPages', type: :request do
  subject { page }

  describe 'signup page' do
    before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_title('Sign up') }
  end

  describe 'profile page' do
    let(:user) { FactoryBot.create(:user) }

    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe 'signup' do
    before { visit signup_path }
    let(:submit) { 'Create my account' }
    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    describe 'with valid information' do
      before do
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in '学号', with: '201728001007000'
        fill_in 'Password', with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end
      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end
  end

  describe 'search classes' do
    before {visit search_path}
    describe 'with information' do
      it { should have_title('课程信息') }
      it { should have_content('考试时间') }
    end
  end
  
end
