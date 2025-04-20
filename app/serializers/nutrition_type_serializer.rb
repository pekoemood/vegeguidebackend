class NutritionTypeSerializer
  include JSONAPI::Serializer
  attributes :name, :unit

  has_many :vegetables
end
