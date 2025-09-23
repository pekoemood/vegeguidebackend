class VegetableNutritionSerializer
  include JSONAPI::Serializer
  attributes :amount

  belongs_to :vegetable
  belongs_to :nutrition_type
end
