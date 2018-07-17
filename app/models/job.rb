class Job < ApplicationRecord
    belongs_to :department, 
        foreign_key: :department_id
end
