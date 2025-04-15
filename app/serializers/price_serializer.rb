class PriceSerializer
  include JSONAPI::Serializer
  attributes :vegetable_id, :price, :market, :date, :price_variation
  belongs_to :vegetable, serializer: VegetableSerializer
end
