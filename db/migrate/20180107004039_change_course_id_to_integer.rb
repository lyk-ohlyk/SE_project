class ChangeCourseIdToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :assignments, :course_id, 'integer USING CAST(course_id AS integer)'
  end
end
