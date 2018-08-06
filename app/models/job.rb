class Job < ApplicationRecord
    belongs_to :department, 
        class_name: 'Department',
        foreign_key: :department_id,
        optional: true

    has_many :openings, 
        class_name: 'JobOpening', 
        foreign_key: :job_id

    has_many :job_posts, 
        class_name: 'JobPost', 
        foreign_key: :job_id
end
