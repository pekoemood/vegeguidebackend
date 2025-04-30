class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_user!

  def create
    recipe_data = recipe_params
    result = ShoppingListCreator.new(@current_user, recipe_data).call

    if result[:success]
      render json: { success: true, recipe: result[:recipe]}, status: :created
    else
      render json: { success: false, error: result[:error]}, status: :unprocessable_entity
    end
  end
end


private 

def recipe_params
  params.permit(:name, :instructions, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit], step: [:step_number, :description])
end