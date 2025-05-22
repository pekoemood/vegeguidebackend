class ShoppingListSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name

  attribute :created_at_jst do |object|
    object.created_at.in_time_zone('Tokyo').strftime('%Y年%m月%d日')
  end

  attribute :shopping_items do |shopping_list|
    shopping_list.shopping_list_items.map do |item|
      {
        id: item.ingredient.id,
        name: item.ingredient.name,
        display_amount: item.ingredient.display_amount,
        category: item.ingredient.category,
        checked: item&.checked,
        fromRecipe: item.recipe&.name,
        item_id: item.id 
      }
    end
  end
end
