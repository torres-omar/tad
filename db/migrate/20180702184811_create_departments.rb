class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :parent_id
      t.integer :child_ids, array: true
      t.string :external_id
    end
  end
end
