class Api::V1::ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def index
    current_user_shopping_list = @current_user.shopping_lists.includes(shopping_list_items: [ :ingredient, :recipe ])
    render json: ShoppingListSerializer.new(current_user_shopping_list).serializable_hash.to_json
  end

  def show
    current_user_shopping_list = @current_user.shopping_lists.includes(shopping_list_items: [ :ingredient, :recipe ]).find_by(id: params[:id])
    render json: ShoppingListSerializer.new(current_user_shopping_list).serializable_hash.to_json
  end

  def create
    name = params[:name]
    if name.blank?
      return render json: { status: "failed", message: "リストの名前がありません" }, status: :unprocessable_entity
    end

    new_list = @current_user.shopping_lists.new(name: name)

    if new_list.save
      render json: ShoppingListSerializer.new(new_list).serializable_hash, status: :created
    else
      render json: { status: "failed", message: new_list.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end


  def destroy
    shopping_list = @current_user.shopping_lists.find_by(id: params[:id])
    unless shopping_list
      return render json: { error: "リストが見つかりません" }, status: :not_found
    end

    if shopping_list.destroy
      render json: { success: "リストの削除に成功しました" }, status: :ok
    else
      render json: { error: "リストの削除に失敗しました" }, status: :internal_server_error
    end
  end

  def from_recipe
    recipe = @current_user.recipes.includes(:ingredients).find_by(id: params[:recipe_id])
    return render json: { message: "レシピが見つかりません" }, status: :not_found if recipe.blank?

    ActiveRecord::Base.transaction do
      if params[:shopping_list_id].present?
        shopping_list = @current_user.shopping_lists.find_by(id: params[:shopping_list_id])
      else
        shopping_list = @current_user.shopping_lists.create!(name: params[:name])
      end

      recipe.ingredients.each do |ingredient|
        shopping_list.shopping_list_items.create!(recipe: recipe, ingredient: ingredient)
      end
    end

    render json: RecipeSerializer.new(recipe, params: { current_user: @current_user }).serializable_hash, status: :created
  rescue => e
    render json: { message: "買い物リストの作成に失敗しました", error: e.message }, status: :unprocessable_entity
  end



  private

  # def recipe_params
  #   params.permit(:name, :recipe_category, :instructions, :calorie, :cooking_method, :cooking_time, :purpose, :servings, ingredients: [:name, :amount, :unit, :display_amount, :category], step: [:step_number, :description])
  # end

  # def update_items_params
  #   params.require(:items).map do |item|
  #     item.permit(:id, :checked)
  #   end
  # end
end
