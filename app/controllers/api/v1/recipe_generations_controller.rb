class Api::V1::RecipeGenerationsController < ApplicationController
  def create
    api_response = GeminiClient.new.generate_recipe
    render json: api_response
  end
end
