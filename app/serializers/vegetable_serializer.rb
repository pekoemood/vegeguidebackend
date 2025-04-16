class VegetableSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image_url
  has_many :prices, serializer: PriceSerializer
end
