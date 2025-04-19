class VegetableSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :origin, :storage, :image_url
  has_many :prices, serializer: PriceSerializer
end
