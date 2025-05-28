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
      resources :shopping_lists, only: %i( index show create update destroy ) do
        post :from_recipe, on: :collection
        resources :shopping_list_items, shallow: true do
          patch :batch_update, on: :collection
        end
      end

      resources :recipes, only: %i( index show create destroy )
      resources :fridge_items, only: %i( index create update destroy )

      resources :users, only: %i( create )
      resources :vegetables, only: %i( index show ) do
        get :names, on: :collection
        get :summary, on: :collection
      end
      get "/health", to: proc { [200, { "Content-Type" => "application/json" }, [{ status: "ok" }.to_json]]}
    end
  end
end
