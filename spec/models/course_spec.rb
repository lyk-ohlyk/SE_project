require 'rails_helper'

RSpec.describe Course, type: :model do

  before { @course = FactoryBot.create(:course) }
  subject { @course } #把courses设置为默认的对象
  it { should respond_to(:course_code) }
  it { should respond_to(:course_name) }
  it { should respond_to(:course_time) }
  it { should respond_to(:score) }
  it { should respond_to(:exam_date) }
  it { should respond_to(:exam_hour) }
  it { should respond_to(:exam_place) }

  it { should respond_to(:site_id) }
  it { should respond_to(:assignments) }

  it { should respond_to(:comments)}

  describe 'assignments associations' do
    before { @course.save }
    let!(:older_assignment) do
      FactoryBot.create(:assignment, course: @course, created_at: 1.day.ago)
    end
    let!(:newer_assignment) do
      FactoryBot.create(:assignment, course: @course, created_at: 1.hour.ago)
    end
    it 'should have the right assignments in the right order' do
      expect(@course.assignments.to_a).to eq [newer_assignment, older_assignment]
    end

    it 'should destroy associated assignments' do
      assignments = @course.assignments.to_a
      @course.destroy
      expect(assignments).not_to be_empty
      assignments.each do |assignment|
        expect(Assignment.where(id: assignment.id)).to be_empty
      end
    end
    
  end

end
