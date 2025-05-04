Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  
  require "sidekiq/web"
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  namespace :api do
    namespace :v1 do
      post "recipe_generations", to: "recipe_generations#create"
      post "login", to: "authentication#login"
      post "logout", to: 'authentication#logout'
      get 'check_login_status', to: 'authentication#check_login_status'
      get "show_request", to: "authentication#show_request"
      resources :shopping_lists, only: %i( index show create update destroy )
      resources :recipes, only: %i( create )
      resources :users, only: %i( create )
      resources :vegetables, only: %i( index show )
    end
  end
end
