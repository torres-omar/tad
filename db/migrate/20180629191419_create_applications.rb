class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.integer :candidate_id
      t.boolean :prospect, default: false
      t.datetime :applied_at
      t.datetime :rejected_at
      t.datetime :last_activity_at
      t.json :location
      t.json :source
      t.json :credited_to
      t.json :rejection_reason
      t.json :rejection_details
      t.json :jobs, array: true
      t.string :status
      t.json :current_stage
      t.json :answers, array: true
      t.json :prospect_detail
      t.json :custom_fields
      t.json :keyed_custom_fields
      t.timestamps
    end
  end
end
