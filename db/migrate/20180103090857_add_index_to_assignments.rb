class AddIndexToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_index :assignments, [:course_id, :created_at]
  end
end
