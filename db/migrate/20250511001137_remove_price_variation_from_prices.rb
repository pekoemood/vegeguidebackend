class RemovePriceVariationFromPrices < ActiveRecord::Migration[7.2]
  def change
    remove_column :prices, :price_variation, :decimal
  end
end
