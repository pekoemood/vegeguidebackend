class RecipeCreator
  def initialize(current_user, recipe_data)
    @current_user = current_user
    @recipe_data = recipe_data
  end

  def call
    ActiveRecord::Base.transaction do
      user_recipe = @current_user.recipes.create!(@recipe_data.except(:ingredients, :step, :image_id))
      
      @recipe_data[:ingredients].each do |ingredient|
        user_recipe.ingredients.create!(ingredient)
      end

      @recipe_data[:step].each do |step|
        user_recipe.recipe_steps.create!(step)
      end

      if @recipe_data[:image_id].present?
        blob = ActiveStorage::Blob.find_signed(@recipe_data[:image_id])
        user_recipe.image.attach(blob)
      end
    end

  rescue => e 
    Rails.logger.error("レシピ作成中のエラー: #{e.message}")
    raise
  end
end