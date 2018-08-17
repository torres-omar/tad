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
        get '/update-guild-data', to: 'guilds#update_guilds', defaults: {format: :json}
        namespace :guilds do 
            get '/culinary', to: 'culinary#show'
            get '/customer-experience', to: 'customer_experience#show'
            get '/data-science', to: 'data_science#show'
            get '/finance', to: 'finance#show'
            get '/legal', to: 'legal#show'
            get '/marketing', to: 'marketing#show'
            get '/operations', to: 'operations#show'
            get '/people', to: 'people#show'
            get '/product', to: 'product#show'
            get '/technology', to: 'technology#show'
        end
        get '/', to: redirect('/dashboard/overview')
    end

    namespace :charts, defaults: {format: :json} do
      namespace :overview do 
        get '/hires-by-years-months', to: 'hires#hires_by_year_and_month'
        get '/hires-per-year', to: 'hires#hires_per_year'
        get '/hires-statistics', to: 'hires#hires_statistics_for_year'
        get '/offer-acceptance-ratios', to: 'offers#offer_acceptance_ratios'
        get '/month-year-offer-acceptance-ratio', to: 'offers#month_year_offer_acceptance_ratio'
        get '/year-offer-acceptance-ratio', to: 'offers#year_offer_acceptance_ratio'
        get '/most-recent-hire', to: 'hires#most_recent_hire'
      end

      namespace :guilds do 
        get '/hires-by-guild-for-year', to: 'hires#hires_by_guild_for_year'
        get '/hires-by-year-for-guild', to: 'hires#hires_by_year_for_guild'
        get '/hires-by-source-for-guild', to: 'hires#hires_by_source_for_guild'
      end
    end
    
    match '/pusher/auth', to: 'pusher#auth', defaults: {format: :json}, via: [:post]

    namespace :external_source do 
        match 'offers/update', to: 'offers#update', via: [:post]
        match 'offers/create', to: 'offers#create', via: [:post]
        match 'offers/delete', to: 'offers#delete', via: [:post]
    end
end
