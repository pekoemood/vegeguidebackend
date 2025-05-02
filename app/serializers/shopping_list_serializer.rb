class ShoppingListSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name

  attribute :created_at_jst do |object|
    object.created_at.in_time_zone('Tokyo').strftime('%Y年%m月%d日')
  end

  attribute :shopping_items do |shopping_list|
    shopping_list.shopping_list_items.map do |item|
      {
        name: item.ingredient.name,
        amount: item.ingredient.amount,
        unit: item.ingredient.unit,
        checked: item.checked
      }
    end
  end
end
