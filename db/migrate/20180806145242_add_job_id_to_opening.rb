class AddJobIdToOpening < ActiveRecord::Migration[5.2]
  def change
    add_column :job_openings, :job_id, :integer 
  end
end
