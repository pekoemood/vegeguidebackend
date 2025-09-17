require 'rails_helper'

RSpec.describe Price, type: :model do
  describe 'バリデーション' do
    context '有効な場合' do
      it '有効なpriceであれば保存できる' do
        price = create(:price)
        expect(price).to be_valid
      end
    end

    context '異常な場合' do
      it 'priceがなければ無効' do
        price = build(:price, price: nil)
        expect(price).not_to be_valid
        expect(price.errors[:price]).to include("can't be blank")
      end
      it 'marketがなければ無効' do
        price = build(:price, market: nil)
        expect(price).not_to be_valid
        expect(price.errors[:market]).to include("can't be blank")
      end
      it 'dateがなければ無効' do
        price = build(:price, date: nil)
        expect(price).not_to be_valid
        expect(price.errors[:date]).to include("can't be blank")
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:vegetable) }

    it 'vegetableとの関連づけ' do
      vegetable = create(:vegetable)
      price = create(:price, vegetable: vegetable)
      expect(price.vegetable).to eq(vegetable)
      expect { vegetable.destroy }.to change { Price.count }.by(-1)
    end

  end

  describe 'クラスメソッド' do
    let(:vegetable) { create(:vegetable) }

    describe '.latest_price_for' do
      it '最新価格を取得' do
        old_price = create(:price, vegetable: vegetable, date: 2.days.ago, price: 100)
        latest_price = create(:price, vegetable: vegetable, date: Date.today, price: 200)
        result = Price.latest_price_for(vegetable.id)
        expect(result).to eq(latest_price)
        expect(result.price).to eq(200)
        expect(result).not_to eq(old_price)
      end

      it '該当する価格がない場合はnil' do
        result = Price.latest_price_for(999)
        expect(result).to be nil
      end
    end

    describe '.compare_last_month' do
      context '2つ以上の価格データがある場合' do
        before do
          create(:price, vegetable: vegetable, date: 2.days.ago, price: 100)
          create(:price, vegetable: vegetable, date: Date.today, price: 120)
        end

        it'価格変動率を計算' do
          change_rate = Price.compare_last_month(vegetable.id)
          expect(change_rate).to eq(20.0) # (120 - 100)/100*100 = 20%
        end
      end

      context '1つしか価格データがない場合' do
        before do
          create(:price, vegetable: vegetable, date: Date.today, price: 100)
        end

        it 'nilを返す' do
          change_rate = Price.compare_last_month(vegetable.id)
          expect(change_rate).to be_nil
        end
      end
    end

    describe '.monthly_average_for' do
      before do
        #1月のデータ
        create(:price, vegetable: vegetable, date: Date.new(2025, 1, 15), price: 100)
        create(:price, vegetable: vegetable, date: Date.new(2025, 1, 20), price: 200)
        #2月のデータ
        create(:price, vegetable: vegetable, date: Date.new(2025, 2, 15), price: 150)
      end

      it '月別平均価格の取得' do
        average = Price.monthly_average_for(vegetable.id)
        expect(average.length).to eq(2)

        #1月の平均は150 (100+200)/2
        january_ave = average.find { |a| a.month == '2025-1-1' }
        expect(january_ave.average_price.to_f).to eq(150.0)
      end
    end
  end

  describe 'スコープ' do
    describe '.vegetable_ids_with_price_drop' do
      let(:vegetable1) { create(:vegetable) }
      let(:vegetable2) { create(:vegetable) }
      let(:vegetable3) { create(:vegetable) }

      before do
        #vegetable1: 価格下落(200 -> 150)
        create(:price, vegetable: vegetable1, date: 2.days.ago, price: 200)
        create(:price, vegetable: vegetable1, date: Date.today, price: 150)

        #vegetable1: 価格上昇(100 -> 120)
        create(:price, vegetable: vegetable2, date: 2.days.ago, price: 100)
        create(:price, vegetable: vegetable2, date: Date.today, price: 120)

        #vegetable3: 価格データが１つのみ
        create(:price, vegetable: vegetable3, date: Date.today, price: 100)
      end

      it '価格が下落した野菜のIDを取得' do
        dropped_ids = Price.vegetable_ids_with_price_drop
        expect(dropped_ids).to include(vegetable1.id)
        expect(dropped_ids).not_to include(vegetable2.id, vegetable3.id)
      end
    end
  end
end