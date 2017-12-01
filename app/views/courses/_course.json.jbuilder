json.extract! course, :id, :course_code, :course_name, :course_time, :score, :exam_date, :exam_hour, :exam_place, :created_at, :updated_at
json.url course_url(course, format: :json)
