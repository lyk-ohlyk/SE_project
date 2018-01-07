class ChangeCourseIdToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :assignments, :course_id, :integer
  end
end
