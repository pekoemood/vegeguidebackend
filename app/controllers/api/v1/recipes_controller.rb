class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    user_recipe = @current_user.recipes
    render json: RecipeSerializer.new(user_recipe).serializable_hash.to_json
  end

  def show
    user_recipe = @current_user.recipes.find_by(id: params[:id])
    render json: RecipeSerializer.new(user_recipe).serializable_hash.to_json
  end

  def destroy
    user_recipe = @current_user.recipes.find_by(id: params[:id])
    if user_recipe
      user_recipe.destroy!
      render json: { message: 'レシピの削除に成功しました' }, status: :ok
    else
      render json: { message: 'レシピが見つかりませんでした' }, status: :not_found
    end
  end


  private 

  def recipe_params
    params.permit(:name, :instructions, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit], step: [:step_number, :description])
  end
end