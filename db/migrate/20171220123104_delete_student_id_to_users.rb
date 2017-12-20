class DeleteStudentIdToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :student_id, :string
  end
end
