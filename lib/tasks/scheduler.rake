namespace :tad do
    namespace :scheduler do
    
        desc 'heroku scheduler - Update jobs, job posts, and job openings.'
        task :update_all_jobs => :environment do 
            Resources::UpdateAllJobs.call
        end
    end
end
