require 'rails_helper'

RSpec.describe Season, type: :model do
  describe 'バリデーション' do
    context '正常なケース' do
      it '有効なシーズンであれば保存できる' do
        season = build(:season)
        expect(season).to be_valid
      end

      it '年末年始をまたぐシーズンも保存できる' do
        season = build(:season, start_month: 12, end_month: 2)
        expect(season).to be_valid
      end
    end

    context '異常なケース' do
      it 'start_monthが必須' do
        season = build(:season, start_month: nil)
        expect(season).not_to be_valid
      end

      it 'end_monthが必須' do
        season = build(:season, end_month: nil)
        expect(season).not_to be_valid
      end

      it 'start_monthは1以上12以下' do
        season = build(:season, start_month: 0)
        expect(season).not_to be_valid

        season = build(:season, end_month: 13)
        expect(season).not_to be_valid
      end

      it 'end_monthは1以上12以下' do
        season = build(:season, end_month: 0)
        expect(season).not_to be_valid

        season = build(:season, end_month: 13)
        expect(season).not_to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:vegetable) }

    it 'vegetableとの関連づけ' do
      vegetable = create(:vegetable)
      season = create(:season, vegetable: vegetable)
      expect(season.vegetable).to eq(vegetable)
    end
  end

  describe '#in_season?' do
    context '通常のシーズン（年を跨がない)' do
      let(:season) { build(:season, start_month: 4, end_month: 6) }


      it '開始付きでは旬' do
        travel_to Date.new(2025, 4, 15) do
          expect(season.in_season?).to be true
        end
      end

      it '中間月では旬' do
        travel_to Date.new(2025, 5, 15) do
          expect(season.in_season?).to be true
        end
      end

      it '終了月では旬' do
        travel_to Date.new(2025, 6, 15) do
          expect(season.in_season?).to be true
        end
      end

      it 'シーズン外ではfalse' do
        travel_to Date.new(2025, 3, 15) do
          expect(season.in_season?).to be false
        end

        travel_to Date.new(2025, 7, 15) do
          expect(season.in_season?).to be false
        end
      end
    end

    context '年末をまたぐシーズン' do
      let(:season) { create(:season, start_month: 11, end_month: 2) }

      it '12月では旬' do
        travel_to Date.new(2024, 12, 15) do
          expect(season.in_season?).to be true
        end
      end

      it '1月では旬' do
        travel_to Date.new(2025, 1, 15) do
          expect(season.in_season?).to be true
        end
      end

      it '2月では旬' do
        travel_to Date.new(2025, 2, 15) do
          expect(season.in_season?).to be true
        end
      end

      it 'シーズン外ではfalse' do
        travel_to Date.new(2024, 10, 15) do
          expect(season.in_season?).to be false
        end
        travel_to Date.new(2025, 3, 15) do
          expect(season.in_season?).to be false
        end
      end
    end
  end

  describe 'in_seasonスコープテスト' do
    describe 'in_season' do
      let!(:spring_season) { create(:season, start_month: 3, end_month: 5) }
      let!(:winter_season) { create(:season, start_month: 12, end_month: 2) }
      let!(:summer_season) { create(:season, start_month: 6, end_month: 8) }

      it '現在が春の場合、春の野菜を取得' do
        travel_to Date.new(2025, 4, 15) do
          in_season_records = Season.in_season
          expect(in_season_records).to include(spring_season)
          expect(in_season_records).not_to include(winter_season, summer_season)
        end
      end

      it '現在が冬の場合、冬の野菜を取得' do
        travel_to Date.new(2025, 1, 15) do
          in_season_records = Season.in_season
          expect(in_season_records).to include(winter_season)
          expect(in_season_records).not_to include(spring_season, summer_season)
        end
      end
    end
  end
end
