class ChangeCourseIdToInteger < ActiveRecord::Migration[5.1]
  def change
    # this line is only for PGSQL
    change_column :assignments, :course_id, 'integer USING CAST(course_id AS integer)'

    # this line is for SQLite3
    # change_column :assignments, :course_id, :integer
  end
end
