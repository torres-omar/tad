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
    
    def self.get_openings_filled_by_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            openings = []
            department.jobs.where("custom_fields ->> 'employment_type' = ? AND id NOT IN (?)", 'Full-time', [571948, 770944]).includes(:openings_objs).find_each do |job| 
                job.openings_objs.find_each do |opening| 
                    if opening.status == 'closed' 
                        if opening.close_reason and [13697,13696].include?(opening.close_reason['id'])
                            days_to_hire = Date.parse(opening.closed_at.to_s).mjd - Date.parse(opening.opened_at.to_s).mjd
                            openings << {office: job.offices[0]['name'], job: job.name, days_to_hire: days_to_hire < 0 ? 0 : days_to_hire, closed_at: opening.closed_at}
                        end
                    end
                end
            end
            openings.sort{|x,y| y[:closed_at] <=> x[:closed_at]}
        end
    end
end
