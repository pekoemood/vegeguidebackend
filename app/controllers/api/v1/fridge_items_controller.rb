class Api::V1::FridgeItemsController < ApplicationController
  def index
    fridge_items = @current_user.fridge_items
    render json: FridgeItemSerializer.new(fridge_items).serializable_hash
  end

  def create
    items = fridge_items_params

    if items.blank?
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

    ActiveRecord::Base.transaction do
      items.each do |item|
        days = category_expire_days[item[:category]] || 3
        expire_date = Date.today + days
        @current_user.fridge_items.create!(name: item[:name], category: item[:category], expire_date: expire_date, display_amount: item[:display_amount])
      end
    end
    fridge_items = @current_user.fridge_items
    render json: FridgeItemSerializer.new(fridge_items).serializable_hash

  rescue => e
    render json: { status: 'failed', message: '材料の登録に失敗しました', error: e.message }, status: :unprocessable_entity
    
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
    fridge_array = params[:fridge]
    fridge_array.map do |item|
      item.permit(:name, :category, :display_amount, :expire_date)
    end
  end

  def update_item_params
    params.require(:fridge).permit(:name, :category, :display_amount, :expire_date)
  end
end


