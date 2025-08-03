class Api::V1::ShoppingListItemsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    shopping_list = @current_user.shopping_lists.find_by(id: params[:shopping_list_id])

    if shopping_list.nil?
      return render json: { status: 'failed', message: '買い物リストが見つかりませんでした' }, status: :not_found
    end

    ingredient = Ingredient.create(new_item_params)
    return render json: { message: '材料の作成に失敗しました' }, status: :unprocessable_entity unless ingredient.persisted?

    item = shopping_list.shopping_list_items.new(
      ingredient: ingredient,
    )

    if item.save
      render json: { status: 'success', message: 'ショッピングアイテムの追加に成功しました', item: item.ingredient.as_json.merge(item_id: item.id) }, status: :created
    else
      render json: { status: 'failed', message: 'アイテムの保存に失敗しました', errors: item.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  def update
    shopping_list_item = ShoppingListItem.find_by(id: params[:id])
    
    if shopping_list_item.nil?
      render json: { status: 'failed', message: '当該のアイテムが見つかりませんでした' }, status: :not_found
      return
    end

    checked = ActiveModel::Type::Boolean.new.cast(params[:checked])

    if shopping_list_item.update(checked: checked)
      render json: { status: 'success', message: 'アイテムの更新に成功しました' }, status: :ok
    else
      render json: { status: 'failed', message: 'アイテムの更新に失敗しました' }, status: :unprocessable_entity
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

  def batch_update
    updates = update_params
    if updates.blank?
      return render json: { status: 'failed', message: 'リクエストデータがありません' }, status: :unprocessable_entity
    end

    errors = []

    ActiveRecord::Base.transaction do
      updates.each do |item|
        shopping_list_item = ShoppingListItem.find_by(id: item[:id])
        unless shopping_list_item
          errors << "ID #{item[:id]}が見つかりませんでした"
          next
        end

        unless shopping_list_item.update(checked: item[:checked])
          errors << "ID #{item[:id]}の更新に失敗しました"
        end

        raise ActiveRecord::Rollback if errors.any?
      end

      if errors.any?
        render json: { status: 'failed', message: '一部または全ての更新に失敗しました', errors: errors }, status: :unprocessable_entity
      else
        render json: { status: 'success' }, status: :ok
      end
    end
  end
    

  private

  def new_item_params
    params.permit(:name, :display_amount, :category)
  end

  def update_params
    params.require(:updates).map do |item|
      item.permit(:id, :checked)
    end
  end
end