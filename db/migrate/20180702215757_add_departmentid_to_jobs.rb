class AddDepartmentidToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :department_id, :integer
  end
end
