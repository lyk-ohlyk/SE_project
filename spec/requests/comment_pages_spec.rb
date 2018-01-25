require 'rails_helper'

RSpec.describe "CommentPages", type: :request do
  subject { page }
  let(:user) { FactoryBot.create(:user) }
  let(:course) { FactoryBot.create(:course) }
  before { sign_in user }

  describe "comment creation" do
    before { visit course_path(course) }

    describe "with invalid information" do
      it "should not create a comment" do
        expect { click_button "发布" }.not_to change(Comment, :count)
      end
      describe "error messages" do
        before { click_button "发布" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'comment_content', with: "Lorem ipsum" }
      it "should create a comment" do
        expect { click_button "发布" }.to change(Comment, :count).by(1)
      end
    end
  end

  describe "comment destruction" do
    before { FactoryBot.create(:comment, user: user, course: course) }
    describe "as correct user" do
      before { visit course_path(course) }
      it "should delete a comment" do
        expect { click_link "删除" }.to change(Comment, :count).by(-1)
      end
    end
  end
end
