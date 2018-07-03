class Application < ApplicationRecord
    # validates :prospect, inclusion: {in: [true, false]}
    # validates :status, inclusion: {in: %w(active rejected hired converted)}
    belongs_to :candidate, 
        class_name: 'Candidate',
        foreign_key: :candidate_id
end
