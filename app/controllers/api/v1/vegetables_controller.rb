class Api::V1::VegetablesController < ApplicationController
  def index
    vegetables = Vegetable.where(id:[3, 11, 12, 25, 27, 28, 30, 39])
    json = VegetableSerializer.new(vegetables).serializable_hash.to_json
    render json: json
  end

  def show
    vegetable = Vegetable.includes(vegetable_nutritions: :nutrition_type).find(params[:id])
    render json: VegetableSerializer.new(vegetable).serializable_hash.to_json
  end

  private 

  def options
    options = {}
    options[:include] = [:prices]
    options
  end
end

#, include: [:prices, :seasons, :nutrition_types, :vegetable_nutritions]