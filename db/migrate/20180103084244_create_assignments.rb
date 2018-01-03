class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.string :title
      t.string :deadline
      t.string :state
      t.string :score

      t.timestamps
    end
  end
end
