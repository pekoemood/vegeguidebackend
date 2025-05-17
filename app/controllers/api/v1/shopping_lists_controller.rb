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

  def update
    ActiveRecord::Base.transaction do
      shopping_list_items = @current_user.shopping_lists.find_by(id: params[:id]).shopping_list_items
      update_items = update_items_params.index_by {|item| item["id"]}
  
      shopping_list_items.each do |item|
        if update_items[item.ingredient_id]
          checked_value = update_items[item.ingredient_id]["checked"]
          item.update!(checked: checked_value)
        end
      end
    end
    render json: {success: "更新に成功しました"}, status: :ok
  rescue => e
    render json: { error: "エラーが発生しました: #{e.message}" }, status: :internal_server_error
  end

  def destroy
    shopping_list = @current_user.shopping_lists.find_by(id: params[:id])
    unless shopping_list
      return render json: { error: 'リストが見つかりません' }, status: :not_found
    end
    
    if shopping_list.destroy
      render json: { success: 'リストの削除に成功しました'}, status: :ok
    else
      render json: { error: 'リストの削除に失敗しました'}, status: :internal_server_error
    end
  end

  def from_recipe
    recipe = @current_user.recipes.find_by(id: params[:recipe_id])
    
    return render json: { message: 'レシピが見つかりません' }, status: :not_found if recipe.blank?

    ActiveRecord::Base.transaction do
      shopping_list = @current_user.shopping_lists.create!(name: recipe.name)
      recipe.ingredients.each do |ingredient|
        shopping_list.shopping_list_items.create!(recipe: recipe, ingredient: ingredient)
      end
    end

    render json: { message: '買い物リストの作成に成功しました' }, status: :created
  rescue => e
    render json: { message: '買い物リストの作成に失敗しました', error: e.message }, status: :unprocessable_entity
  end

  private 

  def recipe_params
    params.permit(:name, :recipe_category, :instructions, :calorie, :cooking_method, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit, :display_amount], step: [:step_number, :description])
  end

  def update_items_params
    params.require(:items).map do |item|
      item.permit(:id, :checked)
    end
  end
end
