require 'rails_helper'

RSpec.describe 'UserPages', type: :request do
  subject { page }

  describe 'signup page' do
    before { visit signup_path }
    it { should have_content('注册') }
    it { should have_title('注册') }
  end

  describe 'profile page' do
    let(:user) { FactoryBot.create(:user) }
    let!(:m1) { FactoryBot.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryBot.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryBot.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end
        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end #following a user

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user) 
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end
        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end # unfollowing a user

    end # follow/unfollow
  end #profile page

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
        fill_in '用户名', with: 'Example User'
        fill_in '邮箱', with: 'user@example.com'
        fill_in '学号', with: '201728001007000'
        fill_in '密码', with: 'foobar'
        fill_in '请确认密码', with: 'foobar'
      end
      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('退出')}
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end
  end

  describe "edit" do
    let(:user) { FactoryBot.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    # describe "forbidden attributes" do
    #   let(:params) do
    #     { user: { admin: true, password: user.password,
    #               password_confirmation: user.password } }
    #   end
    #   #let(:test_path) {user_path(user)}
    #   before { patch user_path(user), params }  #这行行不行？
    #   specify { expect(user.reload).not_to be_admin }
    # end

    describe "page" do
      it { should have_content("修改信息") }
      it { should have_title("Edit user") }
      it { should have_link('修改头像', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "保存" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in '用户名', with: new_name
        fill_in "邮箱", with: new_email
        fill_in "密码", with: user.password
        fill_in "请确认密码", with: user.password
        click_button "保存"
      end
      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('退出', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

  end

  describe "index" do
    # before do
    #   sign_in FactoryBot.create(:user)
    #   FactoryBot.create(:user, name: "Bob", email: "bob@example.com")
    #   FactoryBot.create(:user, name: "Ben", email: "ben@example.com")
    #   visit users_path
    # end
    let(:user) {FactoryBot.create(:user)}
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('用户') }
    it { should have_content('所有用户') }

    describe "pagination" do

      before(:all) {30.times {FactoryBot.create(:user)}}
      after(:all) { User.delete_all}

      it { should have_selector('ul.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }
      describe "as an admin user" do
        let(:admin) { FactoryBot.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end

      describe "admin cannot delete himself (with request)" do
        let(:admin) {FactoryBot.create(:admin)}
        before { sign_in admin, no_capybara: true }
        describe "do delete method" do
          before { delete user_path(admin) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end
  end

  describe "following/followers" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    before { user.follow!(other_user) }
    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      it { should have_title('Following') }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end
    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      it { should have_title('Followers') }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end

  describe 'viewing his lesson' do
    let(:user) { FactoryBot.create(:user) }
    let(:new_lesson) { FactoryBot.create(:course) }
    before { user.learn!(new_lesson) }
    describe 'learner' do
      before do
        sign_in user
        visit lessons_user_path(user)
      end
      it { should have_title('我的课程')}
      it { should have_selector('h3', text: '课程') }
      it { should have_link('详情', href: course_path(new_lesson)) }
    end
  end

  describe 'learning/unlearning a new lesson via click' do
    let(:user) { FactoryBot.create(:user) }
    let(:new_lesson) { FactoryBot.create(:course) }
    before { sign_in user }

    describe 'learning a lesson' do
      before { visit course_path(new_lesson) }
      it 'should increment the learning lessons count' do
        expect do
          click_button 'Add'
        end.to change(user.lessons, :count).by(1)
      end
      describe 'toggling the button' do
        before { click_button "Add" }
        it { should have_xpath("//input[@value='Remove']") }
      end
    end

    describe 'unlearning a lesson' do
      before do
        user.learn!(new_lesson)
        visit course_path(new_lesson)
      end
      it 'should decrement the learning lesson count' do
        expect do
          click_button 'Remove'
        end.to change(user.lessons, :count).by(-1)
      end
      describe 'toggling the button' do
        before { click_button 'Remove' }
        it { should have_xpath("//input[@value='Add']") }
      end

    end

  end

end
