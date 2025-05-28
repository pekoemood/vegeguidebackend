class FridgeItemSerializer
  include JSONAPI::Serializer

  attributes :name, :category, :display_amount, :expire_date, :created_at

  attribute :created_day do |object|
    object.created_at.strftime("%Y-%m-%d")
  end
end
