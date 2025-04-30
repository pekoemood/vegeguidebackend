class ShoppingListSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name

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
