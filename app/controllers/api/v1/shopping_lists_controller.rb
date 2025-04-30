class Api::V1::ShoppingListsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    recipe_data = recipe_params
    result = ShoppingListCreator.new(@current_user, recipe_data).call
    shopping_list = result[:shopping_list]

    if result[:success]
      render json: ShoppingListSerializer.new(shopping_list).serializable_hash.to_json
    else
      render json: {success: false, error: result[:error]}, status: :unprocessable_entity
    end
  end

  private 

  def recipe_params
    params.permit(:name, :instructions, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit], step: [:step_number, :description])
  end
end
