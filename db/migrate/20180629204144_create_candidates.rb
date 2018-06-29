class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :title
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :last_activity
      t.boolean :is_private
      t.string :photo_url
      t.json :attachments, array: true
      t.integer :application_ids, array: true
      t.json :phone_numbers, array: true
      t.json :addresses, array: true
      t.json :email_addresses, array: true
      t.json :website_addresses, array: true
      t.json :social_media_addresses, array:true
      t.json :recruiter 
      t.json :coordinator 
      t.string :tags, array:true
      t.json :applications, array: true
      t.json :educations, array:true
      t.json :employments, array: true 
      t.json :custom_fields
      t.json :keyed_custom_fields
    end

    remove_column :applications, :created_at
    remove_column :applications, :updated_at
  end
end
