class JobPost < ApplicationRecord
    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id, 
        optional: true
end
