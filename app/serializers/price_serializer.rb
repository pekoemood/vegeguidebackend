class PriceSerializer
  include JSONAPI::Serializer
  attributes :price, :market, :date, :price_variation
  belongs_to :vegetable, serializer: VegetableSerializer
end
