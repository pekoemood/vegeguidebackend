class Api::V1::RecipeGenerationsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    api_response = GeminiClient.new(request_params).generate_recipe
    render json: api_response
  end

  private 

  def request_params
    params.require(:recipe_generation).permit(:cookingTime, :calorie, :category, :difficulty, :servings, :cookingMethod, selectedVegetables: [])
  end
end