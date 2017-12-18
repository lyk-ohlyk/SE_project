require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  # describe "GET /authentication_pages" do
  #   it "works! (now write some real specs)" do
  #     get authentication_pages_index_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  subject {page}

  describe "signin page" do
    before { visit signin_path }
    it { should have_content('登陆') }
    it { should have_title('登陆') }

    describe "with invalid information" do
      before { click_button '登陆' }

      it { should have_title('登陆') }
      it { should have_selector('div.alert.alert-error', text: '无效的') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "with valid information" do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in user
      end
      # before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('登陆', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('登陆') }
      end
    end
  end

  # ----------- 权限限制 -----------
  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryBot.create(:user) }
      # authorization是通过判断是否有remember_token来限制权限的，所以
      # 这里的bot只是用来方便进行visit等访问的便利，相当于未登录的用户，
      # 并不是说bot不能访问自己的页面
      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('登陆') }
        end
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('登陆') }
        end
      end

      describe "he should not see profile or settings" do
        before { visit root_path }
        it{ should_not have_content('Profile')}
        it{ should_not have_content('Settings')}
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button '登陆'
        end
        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryBot.create(:user) }
      let(:wrong_user) { FactoryBot.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end
      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryBot.create(:user) }
      let(:non_admin) { FactoryBot.create(:user) }
      before { sign_in non_admin, no_capybara: true }
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "in the Microposts controller" do
      describe "submitting to the create action" do
        before { post microposts_path }
        specify { expect(response).to redirect_to(signin_path) }
      end
      describe "submitting to the destroy action" do
        before { delete micropost_path(FactoryBot.create(:micropost)) }
        specify { expect(response).to redirect_to(signin_path) }
      end
    end

  end
end
