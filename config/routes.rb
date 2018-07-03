Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # allow users to only sign in and sign out
  devise_for :admins, only: :sessions
  # redirect users to sign in page
  root to: redirect("admins/sign_in")
  
  resources :jobs, only: [:index]
end
