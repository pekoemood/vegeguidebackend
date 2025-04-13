class Api::V1::VegetablesController < ApplicationController
  def index
    vegetables = Vegetable.all
    json = VegetableSerializer.new(vegetables, options).serializable_hash.to_json
    render json: json
  end

  private 

  def options
    options = {}
    options[:include] = [:prices]
    options
  end
end
