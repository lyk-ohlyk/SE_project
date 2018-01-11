require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:course) {FactoryBot.create(:course)}
  let(:user) {FactoryBot.create(:user)}

  before do
  #   @comment = course.comment.new = FactoryBot.create(:comment)
    @comment = user.comments.build(content: 'Lorem ipsum', course_id: course.id)
  end

  subject{@comment}

  it {should respond_to(:content)}
  it {should respond_to(:course_id)}
  it {should respond_to(:user_id)}
  it {should respond_to(:user)}
  it {should respond_to(:course)}
  its(:user) {should eq user}
  its(:course) {should eq course}

  it {should be_valid}

  describe 'when user_id is not present' do
    before{ @comment.user_id = nil}
    it {should_not be_valid}
  end
  describe 'when course_id is not present' do
    before{ @comment.course_id = nil}
    it {should_not be_valid}
  end

  describe 'it should not be more than 140 words' do
    before { @comment.content = 'a' * 141}
    it {should_not be_valid }
  end

end
