Rails.application.routes.draw do
  # allow users to only sign in and sign out
  devise_for :admins, only: :sessions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :admin do 
    root to: "devise/sessions#new"
  end
  
  resources :jobs, only: [:index]
  # # api 
  # scope '/api', defaults: {format: :json} do 
  #   resources :jobs, only: [:index]
  # end
end
