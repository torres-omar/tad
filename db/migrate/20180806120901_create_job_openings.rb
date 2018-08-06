class CreateJobOpenings < ActiveRecord::Migration[5.2]
  def change
    create_table :job_openings do |t|
        t.string :opening_id
        t.string :status
        t.datetime :opened_at 
        t.datetime :closed_at
        t.integer :application_id 
        t.json :close_reason
    end
  end
end
