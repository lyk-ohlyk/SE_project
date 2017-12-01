
class Exam
	def initialize
		@number = 		[""]
		@id = 			[""]
		@class_time = 	[""]
		@class_name = 	[""]
		@score = 		[""]
		@exam_date = 	[""]
		@exam_hour = 	[""]
		@exam_place = 	[""]
	    @@total_num = 0
		@feature_size = 8
    end
    def get_exam(i)
    	data = {}
    	data['number'] = @number[i]
    	data['id'] = @id[i]
    	data['class_time'] = @class_time[i]
    	data['class_name'] = @class_name[i]
    	data['score'] = @score[i]
    	data['exam_date'] = @exam_date[i]
    	data['exam_hour'] = @exam_hour[i]
    	data['exam_place'] = @exam_place[i]
    	data
    end
	def write_data(data)
		if data.size != @feature_size
			warn "can't fit data:"
			#warn "#{data}"
			return
		end
		@number[@@total_num] = 		data[0]
		@id[@@total_num] = 			data[1]
		@class_name[@@total_num] = 	data[2]
		@class_time[@@total_num] = 	data[3]
		@score[@@total_num] = 		data[4]
		@exam_date[@@total_num] = 	data[5]
		@exam_hour[@@total_num] = 	data[6]
		@exam_place[@@total_num] = 	data[7]
		@@total_num += 1
	end
end

test_exams = Exam.new;
File.open("exams_of_class.csv","r+") do |file|
	i = 0
	while line = file.gets
		#line = file.gets
		#puts line
		data = line.split(',')
		test_exams.write_data(data);
		if(i == 24)
			puts line
		end
		i += 1
	end
end

puts test_exams.get_exam(24)['id']
