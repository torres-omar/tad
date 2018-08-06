class CreateJobPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :job_posts do |t|
        t.string :title
        t.json :location
        t.boolean :internal
        t.boolean :external 
        t.boolean :active
        t.boolean :live
        t.integer :job_id
        t.string :content
        t.string :internal_content
        t.datetime :updated_at
        t.datetime :created_at
        t.json :questions, array: true 
    end
  end
end
