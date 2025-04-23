Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  
  require "sidekiq/web"
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  namespace :api do
    namespace :v1 do
      post "recipe_generations", to: "recipe_generations#create"
      resources :vegetables, only: %i( index show )
    end
  end
end
