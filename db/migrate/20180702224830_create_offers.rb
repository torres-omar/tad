class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.integer :version
      t.integer :application_id
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :sent_at
      t.datetime :resolved_at
      t.datetime :starts_at
      t.string :status
      t.json :custom_fields
      t.json :keyed_custom_fields
    end
  end
end
