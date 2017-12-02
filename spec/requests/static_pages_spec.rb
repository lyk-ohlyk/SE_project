require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "search page" do
    it "should have the content 'Course id'" do
      visit '/static_pages/search'
      expect(page).to have_content('Course id')
    end
  end

end
