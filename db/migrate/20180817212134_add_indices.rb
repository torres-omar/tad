class AddIndices < ActiveRecord::Migration[5.2]
  def change
    add_index :offers, :status
    add_index :offers, :job_id
    add_index :offers, :created_at
    add_index :offers, :resolved_at
    add_index :departments, :name
    add_index :jobs, :status
  end
end
