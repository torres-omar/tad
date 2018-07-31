class ExternalSource::Offers::CreateOffer 
    include Callable

    def initialize(params, source_credentials) 
        @offer_params = params
        @new_offer = Offer.new(@offer_params.slice(*Offer.column_names))
        @source_credentials = source_credentials
        @hydra = Typhoeus::Hydra.hydra
    end

    def call
        @new_offer.starts_at = @offer_params['start_date']
        @new_offer.status = @offer_params['offer_status'] == 'Created' ? 'unresolved' : @offer_params['offer_status'].downcase
        @new_offer.custom_fields['employment_type'] = @offer_params['custom_fields']['employment_type']['value']
        @new_offer.save
        # create associated resources, if they don't already exist
        create_associated_application
        create_associated_job 
        client_data = {
            message: 'An offer was created!',
            created_year: @new_offer.created_at.year, 
            created_month: @new_offer.created_at.month 
        }
        
        if @new_offer.version == 1
            Pusher.trigger('private-tad-channel', 'offer-created', client_data)
        end
    end

    def create_associated_application
        application_id = @offer_params['application_id']
        application = Application.find_by(id: application_id)
        unless application
            application_request = Typhoeus::Request.new(
                "https://harvest.greenhouse.io/v1/applications/#{application_id}",
                {
                    method: :get,
                    headers: {"Authorization": 'Basic ' + @source_credentials}
                }
            )

            application_request.on_complete do |response| 
                application = Application.create(JSON.parse(response.body))
                candidate = Candidate.find_by(id: application.candidate_id)
                unless candidate
                    candidate_request = Typhoeus::Request.new(
                        "https://harvest.greenhouse.io/v1/candidates/#{application.candidate_id}",
                        {
                            method: :get, 
                            headers: {"Authorization": "Basic " + @source_credentials}
                        }
                    )
                    
                    candidate_request.on_complete{ |response| Candidate.create(JSON.parse(response.body)) } 
                    @hydra.queue candidate_request
                end
            end

            @hydra.queue application_request
        end
    end

    def create_associated_job
        job_id = @offer_params['job_id']
        job = Job.find_by(id: job_id)
        unless job 
            job_request = Typhoeus::Request.new(
                "https://harvest.greenhouse.io/v1/jobs/#{job_id}",
                {
                    method: :get, 
                    headers: {"Authorization": 'Basic ' + @source_credentials}
                }
            )
            
            job_request.on_complete do |response| 
                job = Job.create(JSON.parse(response.body))
                department_id = job['departments'][0]['id']
                job.department_id = department_id
                job.save
                department = Department.find_by(id: department_id)
                unless department
                    department_request = Typhoeus::Request.new(
                        "https://harvest.greenhouse.io/v1/departments/#{department_id}",
                        {
                            method: :get, 
                            headers: {"Authorization": 'Basic ' + @source_credentials}
                        }
                    )

                    department_request.on_complete{ |response| Department.create(JSON.parse(response.body)) } 
                    @hydra.queue department_request
                end
            end

            @hydra.queue job_request
        end
        @hydra.run
    end
end
