require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "search page" do
    it "should have the content 'Course id'" do
      visit '/static_pages/search'
      expect(page).to have_content('Course id')
    end
  end
  describe "Home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
  end
end
