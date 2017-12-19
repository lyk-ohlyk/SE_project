class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id

    # 设置组合索引，确保(follower_id, followed_id)组合是唯一的
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
