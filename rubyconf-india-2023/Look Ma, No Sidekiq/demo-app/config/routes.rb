Rails.application.routes.draw do
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "articles#index"

  get "/io" => "benchmark#io"
  get "/io2" => "benchmark#io2"
  get "/cpu" => "benchmark#cpu"
  get "/synthetic" => "benchmark#synthetic"
  get "/external" => "benchmark#external"

  resources :users

  namespace :external do
    resources :users
  end

  root "users#home"
end
