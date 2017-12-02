class CreateStudentIds < ActiveRecord::Migration[5.1]
  def change
    create_table :student_ids do |t|
      t.string :number
      t.string :pwd

      t.timestamps
    end
  end
end
