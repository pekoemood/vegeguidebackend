class RecipeSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :instructions, :cooking_time, :servings, :difficulty

  attribute :ingredients do |recipe|
    recipe.ingredients.map do |ingredient|
      {
        name: ingredient.name,
        amount: ingredient.amount,
        unit: ingredient.unit,
        display_amount: ingredient.display_amount,
        category: ingredient.category,
      }
    end
  end

  attribute :recipe_steps do |recipe|
    recipe.recipe_steps.map do |step|
      {
        step_number: step.step_number,
        description: step.description,
      }
    end
  end
end
