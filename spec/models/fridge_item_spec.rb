require 'rails_helper'

RSpec.describe FridgeItem, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '正しい値なら保存される' do
        fridge_item = build(:fridge_item)
        expect(fridge_item).to be_valid
      end
    end

    context '異常系' do
      it '名前がないと保存されない' do
        fridge_item = build(:fridge_item, name: nil)
        expect(fridge_item).not_to be_valid
        expect(fridge_item.errors[:name]).to include("can't be blank")
      end

      it 'カテゴリーがないと保存されない' do
        fridge_item = build(:fridge_item, category: nil)
        expect(fridge_item).not_to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    
    it '関連付けができる' do
      user = create(:user)
      fridge_item = create(:fridge_item, user: user)
      expect(fridge_item.user).to eq(user)
    end

    it 'ユーザーが削除されると冷蔵庫アイテムも削除される' do
      user = create(:user)
      create(:fridge_item, user: user)
      expect { user.destroy }.to change { FridgeItem.count }.by(-1)
    end
  end

  describe '#expire_status' do
    let(:expired) { create(:fridge_item, expire_date: 1.days.ago) }
    let(:urgent) { create(:fridge_item, expire_date: 2.days.from_now) }
    let(:warning) { create(:fridge_item, expire_date: 5.days.from_now) }
    let(:safe) { create(:fridge_item, expire_date: 7.days.from_now) }
    let(:unset) { create(:fridge_item, expire_date: nil) }

    it '期限が過ぎている場合はexpired' do
      expect(expired.expire_status).to eq('expired')
    end

    it '期限が2日後であればurgent' do
      expect(urgent.expire_status).to eq('urgent')
    end

    it '期限が5日後であればwarning' do
      expect(warning.expire_status).to eq('warning')
    end

    it '期限が6日以上後であればsafe' do
      expect(safe.expire_status).to eq('safe')
    end

    it '期限が設定されていなければunset' do
      expect(unset.expire_status).to eq('unset')
    end
  end
end
