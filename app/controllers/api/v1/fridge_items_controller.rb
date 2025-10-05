class Api::V1::FridgeItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    fridge_items = @current_user.fridge_items
    render json: FridgeItemSerializer.new(fridge_items).serializable_hash
  end

  def create
    items = fridge_items_params

    if items.blank?
      return render json: { status: "failed", message: "リクエストデータに不備があります" }, status: :unprocessable_entity
    end

    category_expire_days = {
      "野菜" => 5,
      "肉類" => 3,
      "魚介類"  => 2,
      "卵・乳製品" => 7,
      "豆・豆製品" => 4,
      "穀類・パン" => 5,
      "調味料" => 30,
      "加工食品" => 6,
      "その他" => 4
    }

    ActiveRecord::Base.transaction do
      items.each do |item|
        if item[:expire_date].blank?
          days = category_expire_days[item[:category]] || 3
          expire_date = Time.zone.today + days
        end

        if item[:category] == "調味料"
          @current_user.fridge_items.find_or_create_by(name: item[:name], category: item[:category])
        else
          existing_item = @current_user.fridge_items.find_by(name: item[:name], category: item[:category])
          if existing_item.present? && existing_item.unit == item[:unit]
            before_amount = existing_item.amount.to_i
            new_amount = item[:amount].to_i
            total_amount = before_amount + new_amount
            if total_amount <= 0
              display_amount = nil
            else
              display_amount = "#{total_amount}#{existing_item.unit}"
            end
            existing_item.update!(display_amount: display_amount, amount: total_amount)
          else
            @current_user.fridge_items.create!(name: item[:name], category: item[:category], expire_date: expire_date || item[:expire_date], display_amount: item[:display_amount], amount: item[:amount], unit: item[:unit])
          end
        end
      end
    end
    fridge_items = @current_user.fridge_items
    render json: FridgeItemSerializer.new(fridge_items).serializable_hash

  rescue => e
    render json: { status: "failed", message: "食材の登録に失敗しました", error: e.message }, status: :unprocessable_entity
  end

  def update
    fridge_item = @current_user.fridge_items.find_by(id: params[:id])
    return render json: { status: "failed", message: "食材が見つかりませんでした" }, status: :not_found if fridge_item.blank?

    if fridge_item.update(update_item_params)
      fridge_items = @current_user.fridge_items
      render json: FridgeItemSerializer.new(fridge_items).serializable_hash
    else
      render json: { status: "failed", message: "食材の更新に失敗しました", error: fridge_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    item = @current_user.fridge_items.find_by(id: params[:id])

    if item&.destroy
      fridge_items = @current_user.fridge_items
      render json: FridgeItemSerializer.new(fridge_items).serializable_hash
    else
      render json: { status: "failed", message: "食材の削除に失敗しました" }, status: :unprocessable_entity
    end
  end

  private

  def fridge_items_params
    fridge_array = params[:fridge] || []
    fridge_array.map do |item|
      item.permit(:name, :category, :display_amount, :expire_date, :amount, :unit)
    end
  end

  def update_item_params
    params.require(:fridge).permit(:name, :category, :display_amount, :expire_date)
  end
end
