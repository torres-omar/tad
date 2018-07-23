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
        get '/new-hires-years', to: 'hires#new_hires_per_year'
        get '/offer-acceptance-ratios', to: 'offers#offer_acceptance_ratios'
        get '/month-year-offer-acceptance-ratio', to: 'offers#month_year_offer_acceptance_ratio'
        get '/year-offer-acceptance-ratio', to: 'offers#year_offer_acceptance_ratio'
      end
    end
    
    match '/pusher/auth', to: 'pusher#auth', defaults: {format: :json}, via: [:post]

    get '/stages', to: 'jobs#stages', defaults: {format: :json}
end
