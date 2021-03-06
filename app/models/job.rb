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

    # two functions below could be merged into one function
    def self.get_live_jobs_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            live_jobs = []
            department_ids = department.name == 'Marketing' ? [department.id, Department.find_by(name: 'Creative').id] : [department.id]
            Job.includes(:job_posts).where("status = ? AND id NOT IN (?) AND custom_fields ->> 'employment_type' = ? AND department_id IN (?)", 'open', FILTERED_JOB_IDS, 'Full-time', department_ids).find_each do |job| 
                if job.job_posts.any?{ |post| post.live }
                    live_jobs << job 
                end
            end
            live_jobs
        end
    end

    def self.get_live_openings_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            live_openings = []
            department_ids = department.name == 'Marketing' ? [department.id, Department.find_by(name: 'Creative').id] : [department.id]
            Job.includes(:job_posts, :openings_objs).where("status = ? AND id NOT IN (?) AND custom_fields ->> 'employment_type' = ? AND department_id IN (?)", 'open', FILTERED_JOB_IDS, 'Full-time', department_ids).find_each do |job| 
                if job.job_posts.any?{|post| post.live}
                    job.openings_objs.find_each{ |opening| live_openings << opening if opening.status == 'open'}
                end
            end
            live_openings
        end
    end

    def self.get_percent_of_open_jobs_for_department_data(department_name)
        # get total number of live, full-time jobs in plated and total number of live, full-time jobs in department
        live_jobs_count = 0
        department_live_jobs_count = 0
        Job.includes(:job_posts, :department).where("id NOT IN (?) AND custom_fields ->> 'employment_type' = ? AND status = ?", FILTERED_JOB_IDS, 'Full-time', 'open').find_each do |job|
            if job.job_posts.any?{|post| post.live }
                live_jobs_count += 1 
                if department_name == 'Marketing'
                    department_live_jobs_count += 1 if job.department.name == department_name || job.department.name == 'Creative'
                else
                    department_live_jobs_count += 1 if job.department.name == department_name
                end
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
            # merge marketing and creative
            department_ids = department.name == 'Marketing' ? [department.id, Department.find_by(name: 'Creative').id] : [department.id]
            Job.where("custom_fields ->> 'employment_type' = ? AND id NOT IN (?) AND department_id IN (?)", 'Full-time', FILTERED_JOB_IDS, department_ids).includes(openings_objs: [{application: [:candidate, :offers]}]).find_each do |job| 
                job.openings_objs.find_each do |opening| 
                    if opening.status == 'closed'
                        # check that the opening has an application 
                        if opening.application and opening.application.candidate
                            days_to_hire = Date.parse(opening.closed_at.to_s).mjd - Date.parse(opening.opened_at.to_s).mjd
                            days_to_offer = Date.parse(opening.application.offers.first.created_at.to_s).mjd - Date.parse(opening.application.applied_at.to_s).mjd
                            # days_to_offer = Date.parse(opening.closed_at.to_s).mjd - Date.parse(opening.application.applied_at.to_s).mjd
                            openings << {office: job.offices[0]['name'], 
                                        job: job.name, 
                                        days_to_hire: days_to_hire < 0 ? 0 : days_to_hire, 
                                        candidate_hired: opening.application.candidate.first_name + ' ' + opening.application.candidate.last_name,
                                        days_to_offer: days_to_offer < 0 ? 0 : days_to_offer,
                                        closed_at: Date.parse(MONTH_NAMES[opening.closed_at.month].to_s + ' ' + opening.closed_at.day.to_s + ' ' + opening.closed_at.year.to_s), 
                                        }             
                        end
                    end
                end
            end
            openings.sort{|x,y| y[:closed_at] <=> x[:closed_at]}
        end
    end

     def self.get_open_jobs_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            department.jobs.where('status = ?', 'open')
        end 
    end

    def self.get_openings_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            openings = []
            department.jobs.includes(:openings_objs).where('status = ?', 'open').find_each do |job| 
                job.openings_objs.each{ |opening| openings << opening if opening.status == 'open' }
            end
            openings
        end
    end

    def self.get_closed_jobs_for_department(department_name)
        department = Department.find_by(name: department_name)
        if department
            department.jobs.where('status = ?', 'closed')
        end 
    end
end
