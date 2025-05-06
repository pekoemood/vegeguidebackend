class VegetableSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :origin, :storage, :image_url

  attribute :prices do |vegetable|
    vegetable.prices.map do |vp|
      {
        price: vp.price,
        market: vp.market,
        date: vp.date,
        price_variation: vp.price_variation,
      }
    end
  end

  attribute :seasons do |vegetable|
    vegetable.seasons.map do |vs|
      {
        start_month: vs.start_month,
        end_month: vs.end_month,
        note: vs.note,
        in_season: vegetable.in_season?
      }
    end
  end


  attribute :nutritions do |vegetable|
    vegetable.vegetable_nutritions.map do |vn|
      {
        name: vn.nutrition_type.name,
        amount: vn.amount,
        unit: vn.nutrition_type.unit
      }
    end
  end
end
