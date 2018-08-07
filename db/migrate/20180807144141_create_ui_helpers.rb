class CreateUiHelpers < ActiveRecord::Migration[5.2]
  def change
    create_table :ui_helpers do |t|
        t.string :name
        t.datetime :last_updated
        t.boolean :updating
    end

    add_index :ui_helpers, :name
    remove_column :departments, :last_updated
  end
end
