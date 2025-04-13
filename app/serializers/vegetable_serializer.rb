class VegetableSerializer
  include JSONAPI::Serializer
  attributes :id, :name
  has_many :prices, serializer: PriceSerializer
end
