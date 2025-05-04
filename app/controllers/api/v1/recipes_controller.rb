class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    user_recipe = @current_user.recipes
    render json: RecipeSerializer.new(user_recipe).serializable_hash.to_json
  end



  private 

  def recipe_params
    params.permit(:name, :instructions, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit], step: [:step_number, :description])
  end
end