class Api::V1::ShoppingListItemsController < ApplicationController
  def create
    shopping_list = @current_user.shopping_lists.find_by(id: params[:shopping_list_id])

    if shopping_list.nil?
      render json: { status: 'failed', message: '買い物リストが見つかりませんでした' }, status: :not_found
    end

    ingredient = Ingredient.create!(new_item_params)

    item = shopping_list.shopping_list_items.new(
      ingredient: ingredient,
    )

    if item.save
      render json: { status: 'success', message: 'ショッピングアイテムの追加に成功しました', item: item.ingredient }, status: :created
    else
      render json: { status: 'failed', message: 'アイテムの保存に失敗しました', errors: item.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  def destroy
    shopping_list_item = ShoppingListItem.find_by(id: params[:id])
    if shopping_list_item.nil?
      render json: { status: 'failed', message: '該当のアイテムが見つかりませんでした' }, status: :not_found
      return
    end

    if shopping_list_item.destroy
      render json: { status: 'success', message: 'アイテムの削除に成功しました' }, status: :ok
    else
      render json: { status: 'failed', message: 'アイテムの削除に失敗しました' }, status: :unprocessable_entity
    end
  end
    

  private

  def new_item_params
    params.permit(:name, :display_amount, :category)
  end
end