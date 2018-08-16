class JobOpening < ApplicationRecord
    belongs_to :job, 
        class_name: 'Job', 
        foreign_key: :job_id, 
        optional: true

    belongs_to :application, 
        class_name: 'Application', 
        foreign_key: :application_id, 
        optional: true
end
