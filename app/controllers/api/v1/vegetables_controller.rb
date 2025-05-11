class Api::V1::VegetablesController < ApplicationController
  def index
    page_size = 8
    page_number = params[:page].nil? ? 0 : params[:page].to_i - 1
    total_count = Vegetable.count
    total_pages = (total_count / page_size.to_f).ceil
    option = {
      meta: { 
        total_pages: total_pages,
        current_page: page_number,
      }
    }

    vegetables = Vegetable.includes(:prices, :seasons, vegetable_nutritions: :nutrition_type).limit(page_size).offset(page_number * page_size)
    json = VegetableSerializer.new(vegetables).serializable_hash
    render json: json
  end

  def show
    vegetable = Vegetable.includes(:prices, :seasons, vegetable_nutritions: :nutrition_type).find_by(id: params[:id])
    render json: VegetableSerializer.new(vegetable).serializable_hash
  end
end