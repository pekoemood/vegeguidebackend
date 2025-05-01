class Api::V1::ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def index
    current_user_shopping_list = @current_user.shopping_lists
    render json: ShoppingListSerializer.new(current_user_shopping_list).serializable_hash.to_json
  end

  def show
    current_user_shopping_list = @current_user.shopping_lists.find_by(id: params[:id])
    render json: ShoppingListSerializer.new(current_user_shopping_list).serializable_hash.to_json
  end
  
  def create
    recipe_data = recipe_params
    result = ShoppingListCreator.new(@current_user, recipe_data).call

    if result[:success]
      render json: {success: true }, status: :created
    else
      render json: {success: false, error: result[:error]}, status: :unprocessable_entity
    end
  end

  private 

  def recipe_params
    params.permit(:name, :instructions, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit], step: [:step_number, :description])
  end
end
