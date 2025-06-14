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

  def create
    begin 
      RecipeCreator.new(@current_user, recipe_params).call
      render json: { status: 'success', message: 'レシピの登録に成功しました' }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 'failed', message: e.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
    rescue => e
      render json: { status: 'failed', message: '予期せぬエラーが発生しました' }, status: :internal_server_error
    end
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
    params.except(:recipe).permit(:name, :calorie, :recipe_category, :cooking_method, :instructions, :cooking_time, :purpose, :servings, ingredients: [:name, :amount, :unit, :display_amount, :category], step: [:step_number, :description])
  end
end
