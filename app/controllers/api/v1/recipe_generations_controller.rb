class Api::V1::RecipeGenerationsController < ApplicationController
  def create
    # GeminiClientをインスタンス化して、レシピ生成をリクエスト
    api_response = GeminiClient.new.generate_recipe
    render json: api_response
  end
end
