class AddJobIdToOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :job_id, :integer
  end
end
