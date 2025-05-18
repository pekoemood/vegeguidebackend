class RecipeCreator
  def initialize(current_user, recipe_data)
    @current_user = current_user
    @recipe_data = recipe_data
  end

  def call
    ActiveRecord::Base.transaction do
      user_recipe = @current_user.recipes.create!(@recipe_data.except(:ingredients, :step))
      
      @recipe_data[:ingredients].each do |ingredient|
        user_recipe.ingredients.create!(ingredient)
      end

      @recipe_data[:step].each do |step|
        user_recipe.recipe_steps.create!(step)
      end
    end
  end
end