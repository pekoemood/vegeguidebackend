class Api::V1::VegetablesController < ApplicationController
  before_action :authenticate_user!, only: [:summary]
  def index

    keyword = params[:keyword]
    season = params[:season]
    discounted = params[:discounted]
    

    vegetables = Vegetable.includes(:prices, :seasons, vegetable_nutritions: :nutrition_type)

    if keyword.present?
      vegetables = vegetables.where("vegetables.name LIKE ?", "%#{keyword}%")
    end

    if season == "true"
      vegetables = vegetables.joins(:seasons).merge(Season.in_season)
    end

    if discounted == "true"
      discounted_vegetable_ids = Price.vegetable_ids_with_price_drop
      vegetables = vegetables.where(id: discounted_vegetable_ids)
    end

    page_size = 8
    page_number = params[:page].nil? ? 0 : params[:page].to_i - 1
    total_count = vegetables.count
    total_pages = (total_count / page_size.to_f).ceil
    option = {
      meta: { 
        total_pages: total_pages,
        current_page: page_number,
      }
    }
    
    vegetables = vegetables.limit(page_size).offset(page_number * page_size)

    render json: VegetableSerializer.new(vegetables, option).serializable_hash
  end

  def show
    vegetable = Vegetable.includes(:prices, :seasons, vegetable_nutritions: :nutrition_type).find_by(id: params[:id])
    render json: VegetableSerializer.new(vegetable).serializable_hash
  end

  def names
    names = Vegetable.pluck(:name)
    render json: { names: names }
  end

  def summary
    vegetables = Vegetable.select(:id, :name, :image_url)
    render json: vegetables
  end
end
