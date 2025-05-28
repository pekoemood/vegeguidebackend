class Api::V1::FridgeItemsController < ApplicationController
  def index
    fridge_items = @current_user.fridge_items
    render json: FridgeItemSerializer.new(fridge_items).serializable_hash
  end

  def create
    item = fridge_items_params

    if item.blank?
      return render json: { status: 'failed', message: 'リクエストデータに不備があります' }, status: :unprocessable_entity
    end

    category_expire_days = {
      '野菜' => 5,
      '肉類' => 3,  
      '魚介類'  => 2,  
      '卵・乳製品' => 7,  
      '豆・豆製品' => 4,  
      '穀類・パン' => 5,  
      '調味料' => 30, 
      '加工食品' => 6,  
      'その他' => 4 
    }

    
    days = category_expire_days[item[:category]] || 3
    expire_date = Date.today + days
    create_fridge_item = @current_user.fridge_items.create(name: item[:name], category: item[:category], expire_date: expire_date)

    if create_fridge_item.persisted?
      render json: { status: 'success', message: '材料の保存に成功しました' }, status: :created
    else
      render json: { status: 'failed', message: '材料の保存に失敗しました', errors: create_fridge_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    fridge_item = @current_user.fridge_items.find_by(id: params[:id])
    return render json: { status: 'failed', message: '材料が見つかりませんでした' }, status: :not_found if fridge_item.blank?

    if fridge_item.update(update_item_params)
      fridge_items = @current_user.fridge_items
      render json: FridgeItemSerializer.new(fridge_items).serializable_hash
    else
      render json: { status: 'failed', message: '材料の更新に失敗しました', error: fridge_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    item = @current_user.fridge_items.find_by(id: params[:id])

    if item&.destroy
      fridge_items = @current_user.fridge_items
      render json: FridgeItemSerializer.new(fridge_items).serializable_hash
    else
      render json: { status: 'failed', message: '材料の削除に失敗しました' }, status: :unprocessable_entity
    end
  end

  private

  def fridge_items_params
    params.require(:fridge).permit(:name, :category)
  end

  def update_item_params
    params.require(:fridge).permit(:name, :category, :display_amount, :expire_date)
  end
end


