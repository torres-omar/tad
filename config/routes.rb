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
  
    # overview tab namespace
    namespace :overview do
      get '/', to: redirect('/overview/hires')
      resources :hires, only: [:index]
    end

    resources :jobs, only: [:create], defaults: {format: :json}

    namespace :charts do 
      get '/new-hires-years-months', to: 'hires#new_hires_per_year_and_month'
      match '/change-graph-settings', to: 'hires#change_graph_settings', via: [:post]
      get '/new-hires-years', to: 'hires#new_hires_per_year'
      match '/change-years-graph-settings', to: 'hires#change_years_graph_settings', via: [:post]
    end
    
    match '/pusher/auth', to: 'pusher#auth', defaults: {format: :json}, via: [:post]

    get '/stages', to: 'jobs#stages', defaults: {format: :json}
end
