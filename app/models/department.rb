class Department < ApplicationRecord
    has_many :jobs, 
        class_name: 'Job', 
        foreign_key: :department_id

    def self.get_open_jobs_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            department.jobs.where('status = ?', 'open')
        end 
    end

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

    def self.get_openings_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            openings = []
            department.jobs.where('status = ?', 'open').each do |job| 
                job.openings.each{ |opening| openings << opening if opening.status == 'open' }
            end
            openings
        end
    end

    def self.get_live_openings_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            live_openings = []
            department.jobs.includes(:job_posts, :openings).where('status = ?', 'open').each do |job| 
                if job.job_posts.any?{|post| post.live}
                    job.openings.each{ |opening| live_openings << opening if opening.status == 'open'}
                end
            end
            live_openings
        end
    end
end
