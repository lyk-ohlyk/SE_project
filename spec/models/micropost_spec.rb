require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  # before do
  #   # This code is not idiomatically correct.
  #   @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  # end
  before { @micropost = user.microposts.build(content: "Lorem ipsum")}

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  specify{  expect(@micropost.user).to eq user}
  # its(:user) { should eq user }
  # 不知道为什么不能用its


  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

end
