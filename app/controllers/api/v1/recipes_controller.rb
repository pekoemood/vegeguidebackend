class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_user!





  private 

  def recipe_params
    params.permit(:name, :instructions, :cooking_time, :difficulty, :servings, ingredients: [:name, :amount, :unit], step: [:step_number, :description])
  end
end