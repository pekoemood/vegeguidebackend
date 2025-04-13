Rails.application.routes.draw do
  resources :todos, only: %i( index )

  get "up" => "rails/health#show", as: :rails_health_check
  
  require "sidekiq/web"
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  root "todos#index"

  namespace :api do
    namespace :v1 do
      resources :vegetables, only: %i( index )
    end
  end
end
