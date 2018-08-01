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
        get '/guilds', to: 'guilds#index'
        get '/', to: redirect('/dashboard/overview')
    end

    namespace :charts, defaults: {format: :json} do
      namespace :overview do 
        get '/new-hires-years-months', to: 'hires#new_hires_per_year_and_month'
        get '/new-hires-years', to: 'hires#new_hires_per_year'
        get '/hires-statistics', to: 'hires#hires_statistics_for_year'
        get '/offer-acceptance-ratios', to: 'offers#offer_acceptance_ratios'
        get '/month-year-offer-acceptance-ratio', to: 'offers#month_year_offer_acceptance_ratio'
        get '/year-offer-acceptance-ratio', to: 'offers#year_offer_acceptance_ratio'
        get '/most-recent-hire', to: 'hires#most_recent_hire'
      end
    end
    
    match '/pusher/auth', to: 'pusher#auth', defaults: {format: :json}, via: [:post]

    namespace :external_source do 
        match 'offers/update', to: 'offers#update', via: [:post]
        match 'offers/create', to: 'offers#create', via: [:post]
        match 'offers/delete', to: 'offers#delete', via: [:post]
    end

    get '/test', to: 'offers#test'
end
