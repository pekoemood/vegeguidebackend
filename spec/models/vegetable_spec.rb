require 'rails_helper'

RSpec.describe Vegetable, type: :model do
  describe 'バリデーション' do
    context '正常なケース' do
      it '全ての必須項目があれば有効' do
        vegetable = create(:vegetable)
        expect(vegetable).to be_valid
      end

      it '名前のみでも有効' do
        vegetable = build(:vegetable, name: 'テスト野菜', description: nil, origin: nil, storage: nil, image_url: nil)
        expect(vegetable).to be_valid
      end

    context '異常なケース' do
      it '同名の野菜は無効' do
        vegetable1 = create(:vegetable, :daikon)
        vegetable2 = build(:vegetable, :daikon)
        expect(vegetable2).not_to be_valid
      end

      it '名前が空白' do
        vegetable = build(:vegetable, name: "")
        expect(vegetable).not_to be_valid
        expect(vegetable.errors[:name]).to include("can't be blank")
      end
    end
    end
  end

  describe 'アソシエーション' do
    it { should have_many(:prices).dependent(:destroy) }
    it { should have_many(:seasons).dependent(:destroy) }
    it { should have_many(:vegetable_nutritions).dependent(:destroy) }
    it { should have_many(:nutrition_types).through(:vegetable_nutritions) }
  end

  describe '関連レコードの作成・削除' do
    let(:vegetable) { create(:vegetable) }
    let(:price) { create(:price) }
    it 'pricesを作成できる' do
      price = create(:price, vegetable: vegetable)
      expect(vegetable.prices.count).to eq(1)
      expect(price.vegetable).to eq(vegetable)
    end

    it 'vegetable削除時にpricesも削除される' do
      create(:price, vegetable: vegetable)
      vegetable_id = vegetable.id

      expect { vegetable.destroy }.to change { Price.count }.by(-1)
      expect(Price.where(vegetable_id: vegetable_id)).to be_empty
    end
  end

  describe 'season関連' do
    let!(:vegetable) { create(:vegetable) }
    let!(:season) { create(:season, vegetable: vegetable) }
    it 'seasonを作成できる' do
      expect(vegetable.seasons.count).to eq(1)
      expect(season.vegetable).to eq(vegetable)
    end

    it 'vegetable削除時にseasonsも削除される' do
      expect { vegetable.destroy }.to change { Season.count }.by(-1)
    end
  end

  describe 'nutrition_types through関連' do
    let(:vegetable) { create(:vegetable) }
    let(:nutrition_type) { create(:nutrition_type) }

    it 'nutrition_typesを関連づけできる' do
      vegetable.vegetable_nutritions.create(
        nutrition_type: nutrition_type,
        amount: 50
      )

      expect(vegetable.nutrition_types).to include(nutrition_type)
      expect(vegetable.nutrition_types.count).to eq(1)
    end
  end
end
