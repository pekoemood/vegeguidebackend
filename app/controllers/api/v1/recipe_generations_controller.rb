class Api::V1::RecipeGenerationsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    vegetable_name = params[:vegetable]
    api_response = GeminiClient.new(vegetable_name).generate_recipe
    render json: api_response
  end
end
