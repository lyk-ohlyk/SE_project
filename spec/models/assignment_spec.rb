require 'rails_helper'

RSpec.describe Assignment, type: :model do
  let(:course) {FactoryBot.create(:course)}
  before do
    @assignment = course.assignments.build(
                                title: '第一次作业',
                                deadline: '2019-0-0',
                                state: '已提交的',
                                score: 'A+'
    )
  end
  subject{@assignment}

  it {should respond_to(:title)}
  it {should respond_to(:deadline)}
  it {should respond_to(:state)}
  it {should respond_to(:score)}
  it {should respond_to(:course_id)}
  its(:course) {should eq course}

  it {should be_valid}
  describe 'when course_id is not present' do
    before {@assignment.course_id = nil}
    it{should_not be_valid}
  end

end
