class Department < ApplicationRecord
    has_many :jobs, 
        class_name: 'Job', 
        foreign_key: :department_id
end
