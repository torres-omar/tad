class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :requisition_id
      t.string :notes
      t.boolean :confidential
      t.string :status
      t.datetime :created_at
      t.datetime :opened_at
      t.datetime :closed_at
      t.json :departments, array: true 
      t.json :offices, array: true
      t.json :custom_fields
      t.json :keyed_custom_fields
      t.json :hiring_team
      t.json :openings, array: true 
    end
  end
end
