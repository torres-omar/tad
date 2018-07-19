Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    # allow users to only sign in and sign out
    devise_for :admins, only: :sessions

    # change url for sign in 
    devise_scope :admin do
        get '/sign-in', to: 'devise/sessions#new'
    end

    # redirect users to sign in page
    root to: redirect("/sign-in")
  
    # dashboard namespace
    namespace :dashboard do
        get '/overview', to: 'overview#index'
        get '/', to: redirect('/dashboard/overview')
    end

    namespace :charts do
      namespace :overview do 
        get '/new-hires-years-months', to: 'hires#new_hires_per_year_and_month'
        match '/change-years-months-graph-settings', to: 'hires#change_years_months_graph_settings', via: [:post]
        get '/new-hires-years', to: 'hires#new_hires_per_year'
        match '/change-years-graph-settings', to: 'hires#change_years_graph_settings', via: [:post]
        get '/offer-acceptance-ratios', to: 'hires#offer_acceptance_ratios'
        match '/change-year-month-ratio-settings', to: 'offers#change_year_month_ratio_settings', via: [:post]
        match '/change-year-ratio-settings', to: 'offers#change_year_ratio_settings', via: [:post]
      end
    end
    
    match '/pusher/auth', to: 'pusher#auth', defaults: {format: :json}, via: [:post]

    get '/stages', to: 'jobs#stages', defaults: {format: :json}
end
