class Api::V1::RecipeGenerationsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    api_response = GeminiNewClient.new(request_params).generate_recipe
    render json: api_response, status: :ok
  end

  private 

  def request_params
    params.require(:recipe_generation).permit(:cookingTime, :calorie, :category, :purpose, :servings, :cookingMethod, selectedVegetables: [])
  end
end