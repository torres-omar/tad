class Job < ApplicationRecord
    belongs_to :department, 
        class_name: 'Department',
        foreign_key: :department_id,
        optional: true

    has_many :openings_objs, 
        class_name: 'JobOpening', 
        foreign_key: :job_id

    has_many :job_posts, 
        class_name: 'JobPost', 
        foreign_key: :job_id

    def self.get_live_jobs_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            live_jobs = [] 
            department.jobs.includes(:job_posts).where('status = ?', 'open').each do |job| 
                if job.job_posts.any?{ |post| post.live }
                    live_jobs << job 
                end
            end
            live_jobs
        end
    end

    def self.get_percent_of_open_jobs_for_department_data(department_name)
        # get total number of live jobs in plated and total number of live jobs in department
        live_jobs_count = 0
        department_live_jobs_count = 0
        Job.includes(:job_posts, :department).find_each do |job|
            if job.job_posts.any?{|post| post.live }
                live_jobs_count += 1 
                department_live_jobs_count += 1 if job.department.name == department_name
            end
        end
        percent = department_live_jobs_count / live_jobs_count.to_f
        percent = percent.nan? ? 0 : (percent * 100).round
        return {total: live_jobs_count, department: department_live_jobs_count, percent: percent, decimal: percent / 100.0}
    end 
    
end
