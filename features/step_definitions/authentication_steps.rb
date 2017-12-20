Given /^a user visits the signin page$/ do
  visit signin_path
end
When /^he submits invalid signin information$/ do
  click_button '登陆'
end
Then /^he should see an error message$/ do
  expect(page).to have_selector('div.alert.alert-error')
end
Given /^the user has an account$/ do
  @user = User.create(name: "Example User", email: "user@example.com",
                      student_id: "123412341324132",
                      password: "foobar", password_confirmation: "foobar")
end
When /^the user submits valid signin information$/ do
  fill_in '邮箱', with: @user.email
  fill_in '密码', with: @user.password
  click_button '登陆'
end
Then /^he should see his profile page$/ do
  expect(page).to have_title(@user.name)
end

Then /^he should see a signout link$/ do
  expect(page).to have_link('Sign out', href: signout_path)
end