class ShoppingListCreator
  def initialize(current_user, recipe_data)
    @current_user = current_user
    @recipe_data = recipe_data
  end

  def call
    ActiveRecord::Base.transaction do
      recipe = create_recipe

      if recipe.persisted?
        add_to_shopping_list(recipe)
        return { success: true }
      else
        raise ActiveRecord::Rollback, 'レシピ作成に失敗しました'
      end
    end
  rescue => e 
    { success: false, error: e.message }
  end

  private 

  def create_recipe
    recipe = @current_user.recipes.find_or_create_by(@recipe_data.except(:ingredients, :step))
    @recipe_data[:ingredients].each do |ingredient|
      recipe.ingredients.create(ingredient)
    end

    @recipe_data[:step].each do |step|
      recipe.recipe_steps.create(step)
    end
    return recipe
  end

  def add_to_shopping_list(recipe)
    shopping_list = @current_user.shopping_lists.find_or_create_by(name: '買い物リスト')

    recipe.ingredients.each do |ingredient|
      shopping_list.shopping_list_items.create!(ingredient: ingredient, recipe: recipe)
    end
  end
end