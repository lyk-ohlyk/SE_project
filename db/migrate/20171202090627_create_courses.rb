class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :course_code
      t.string :course_time
      t.string :course_name
      t.string :score
      t.string :exam_date
      t.string :exam_hour
      t.string :exam_place

      t.timestamps
    end
  end
end
