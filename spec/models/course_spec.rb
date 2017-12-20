require 'rails_helper'

RSpec.describe Course, type: :model do

  before { @course = Course.new(course_code:'test1',
                              course_name:'test2',
                              course_time:'test3',
                              score:'test4',
                              exam_date:'test5',
                              exam_hour:'test6',
                              exam_place:'test7') }
  subject { @course } #把users设置为默认的对象
  it { should respond_to(:course_code) }
  it { should respond_to(:course_name) }
  it { should respond_to(:course_time) }
  it { should respond_to(:score) }
  it { should respond_to(:exam_date) }
  it { should respond_to(:exam_hour) }
  it { should respond_to(:exam_place) }

end
