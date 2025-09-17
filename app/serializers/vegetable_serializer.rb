class VegetableSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :origin, :storage, :image_url

  attribute :monthly_prices do |vegetable|
    Price.monthly_average_for(vegetable.id).map do |record|
      {
        month: record.month.strftime("%Y-%m"),
        average_price: record.average_price.to_i
      }
    end
  end

  attribute :latest_price do |vegetable|
    price = Price.latest_price_for(vegetable.id)
      {
        latest_price: price.price
      }
  end

  attribute :compare_last_month do |vegetable|
    change_rate = Price.compare_last_month(vegetable.id)
      {
        compare_price: change_rate
      }
  end

  attribute :seasons do |vegetable|
    vegetable.seasons.map do |vs|
      {
        start_month: vs.start_month,
        end_month: vs.end_month,
        note: vs.note,
        in_season: vs.in_season?
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
