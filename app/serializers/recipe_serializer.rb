class RecipeSerializer
  include JSONAPI::Serializer


  attributes :id, :name, :instructions, :cooking_time, :servings, :purpose, :recipe_category

  attribute :image_url do |recipe, params|
    if recipe.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(recipe.image)
    end
  end

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

  attribute :shopping_lists do |recipe, params|
    current_user = params[:current_user]
    next [] unless current_user

    shopping_lists = current_user.shopping_lists
    shopping_lists.map do |list|
      {
        id: list.id,
        name: list.name,
        updated: list.updated_days_ago,
        items_count: list.shopping_list_items.count,
        checked_count: list.shopping_list_items.where(checked: true).count,
        already_added: list.shopping_list_items.exists?(recipe_id: recipe.id)
      }
    end
  end
end
