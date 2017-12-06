require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do

  subject { page }
  describe 'Home page' do
    before {visit root_path}
    it 'should have the h1 "Moyu"' do
      expect(page).to have_content('Moyu')
    end
    it {should have_title('Moyu')}
    it {should_not have_title('| Home')}
  end

  describe 'Help page' do
    before {visit help_path}
    it {should have_content('Help')}
    it {should have_title('Help')}
  end

  describe 'About page' do
    before {visit about_path}
    it {should  have_content('About Us')}
    it {should have_title('About Us')}
  end

  describe 'Contact page' do
    before {visit contact_path}
    it {should have_content('Contact')}
    it {should have_title('Moyu | Contact')}
  end
end
