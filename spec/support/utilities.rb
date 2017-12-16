include ApplicationHelper
# 我用valid_signin测试会失败，具体原因待查
# 他就是说找不到这个方法,很气
# -- 已解决，在rails_helper.rb里加了下面这句
# Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def valid_signin(user)
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button '登陆'
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end


# public_method  #=> 用这个也没用
def sign_in(user, options={})
  if options[:no_capybara]
# Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email", with: user.email.upcase
    fill_in "Password", with: user.password
    click_button '登陆'
  end
end