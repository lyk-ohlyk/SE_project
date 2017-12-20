class CreateRelatecourses < ActiveRecord::Migration[5.1]
  def change
    create_table :relatecourses do |t|
      t.integer :learner_id
      t.integer :lesson_id

      t.timestamps

    end

    add_index :relatecourses, :learner_id
    add_index :relatecourses, [:learner_id, :lesson_id], unique: true
  end
end
