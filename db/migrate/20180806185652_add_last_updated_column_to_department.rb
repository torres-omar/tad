class AddLastUpdatedColumnToDepartment < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :last_updated, :datetime
  end
end
