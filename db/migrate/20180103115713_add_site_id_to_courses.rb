class AddSiteIdToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :site_id, :string
  end
end
