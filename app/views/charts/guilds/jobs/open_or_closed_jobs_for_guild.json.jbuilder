if @jobs.length > 0
    json.array! @jobs do |job|
        json.extract! job, :id
        json.label job.name + ', ' + job.offices[0]['name']
    end
end
