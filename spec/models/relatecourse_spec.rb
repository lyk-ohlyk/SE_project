require 'rails_helper'

RSpec.describe Relatecourse, type: :model do

  let(:learner) { FactoryBot.create(:user)}
  let(:lesson) { FactoryBot.create(:course)}
  let(:relatecourse) {learner.relatecourses.build(lesson_id: lesson.id)}

  subject { relatecourse }
  it { should be_valid }

  describe "learner methods" do
    it { should respond_to(:learner) }
    # it { should respond_to(:lesson) }
    its(:learner) {should eq learner}
    # its(:lesson) {should eq lesson}
  end

  describe "when learner id is not present" do
    before { relatecourse.learner_id = nil }
    it { should_not be_valid }
  end


end
