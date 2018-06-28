Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "pages#home"

  resources :jobs, only: [:index]
  # api 
  scope '/api', defaults: {format: :json} do 
    resources :jobs, only: [:index]
  end
end
