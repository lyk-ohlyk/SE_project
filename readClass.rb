class Exam
def initialize
@number = [""]
@course_code = [""]
@course_time = [""]
@course_name = [""]
@score = [""]
@exam_date = [""]
@exam_hour = [""]
@exam_place = [""]
@@total_num = 0
@feature_size = 8
end
def get_exam(i)
data = {}
data['number'] = @number[i]
data['course_code'] = @course_code[i]
data['course_time'] = @course_time[i]
data['course_name'] = @course_name[i]
data['score'] = @score[i]
data['exam_date'] = @exam_date[i]
data['exam_hour'] = @exam_hour[i]
data['exam_place'] = @exam_place[i]
data
end
def read_data(data)
if data.size != @feature_size
warn "can't fit data:"
return
end
temp_course = Course.new(
course_code:"#{data[1]}",
course_name:"#{data[2]}", 
course_time:"#{data[3]}", 
score:"#{data[4]}", 
exam_date:"#{data[5]}", 
exam_hour:"#{data[6]}", 
exam_place:"#{data[7]}"
)
if !temp_course.save
warn "save error"
end
end
end
test_exams = Exam.new;
File.open("C:\\Users\\atu\\Documents\\GitHub\\SE_project\\exams_of_class.csv","r+") do |file|
i = 0
while line = file.gets
line = line.encode(Encoding.find("UTF-8"), Encoding.find("GBK"))
data = line.split(',')
test_exams.read_data(data);
if(i == 24)
puts line
end
i += 1
end
end
#puts test_exams.get_exam(24)['course_code']
puts "done!!!"