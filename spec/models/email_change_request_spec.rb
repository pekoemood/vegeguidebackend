require 'rails_helper'

RSpec.describe EmailChangeRequest, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user)}

    it '関連付けができる' do
      user = create(:user)
      email = create(:email_change_request, user: user)
      expect(email.user).to eq(user)
    end
  end

  describe 'バリデーション' do
    it '正常系' do
      email = build(:email_change_request)
      expect(email).to be_valid
    end

    it 'new_emailがないと保存されない' do
      email = build(:email_change_request, new_email: nil)
      expect(email).not_to be_valid
    end

    it 'new_emailがメール形式でないと保存されない' do
      email = build(:email_change_request, new_email: 'test')
      expect(email).not_to be_valid
    end

    it 'tokenがないと保存されない' do
      email = build(:email_change_request, token: nil)
      expect(email).not_to be_valid
    end
  end

  describe '#expired?' do
    it 'expired?が正しく動作する' do
      email = create(:email_change_request, expires_at: 1.days.ago)
      expect(email.expired?).to be_truthy
      email.expires_at = 1.days.from_now
      expect(email.expired?).to be_falsey
    end
  end
end
