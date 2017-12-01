require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "Help page" do
    it "should have content '帮助'" do
    	visit '/static_pages/help'
		expect(page).to have_content('帮助')
      #get static_pages_index_path
      #expect(response).to have_http_status(200)
    end

    # #have_title 方法会一直错误，原因待查
    # #原因已知，是由于没有修改application.html.erb
    it "should have title '使用帮助'" do
    	visit '/static_pages/help'
    	expect(page).to have_title("贴心的 | 使用帮助")
    end

  end

end
