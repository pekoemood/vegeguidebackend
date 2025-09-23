require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context '有効な場合' do
      it '有効なユーザーであれば保存できる' do
        user = build(:user)
        expect(user).to be_valid
      end

      it 'google_uidがあれば保存できる' do
        user = build(:google_user)
        expect(user).to be_valid
      end
    end

    context '無効な場合' do
      it '名前がなければ無効' do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('名前の入力は必須です')
      end

      it 'メールアドレスがなければ無効' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスの入力は必須です')
      end

      it 'メールアドレスの形式が誤りであれば無効' do
        user = build(:user, email: 'test-mail')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('無効なメールアドレスです')
      end

      it 'メールアドレスの重複登録は無効' do
        user = create(:user, email: 'test@gmail.com')
        user2 = build(:user, email: 'test@gmail.com')
        expect(user2).not_to be_valid
        expect(user2.errors[:email]).to include('このメールアドレスはすでに使用されています')
      end

      it 'パスワードがなければ無効' do
        user = build(:user, password: '')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('パスワードの入力は必須です')
      end

      it '8文字以下のパスワードは無効' do
        user = build(:user, password: 'pass')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('8文字以上で入力してください')
      end
    end
  end

  describe 'アソシエーション' do
    context 'レシピモデルの場合' do
      it { should have_many(:recipes).dependent(:destroy) }
      it '複数のレシピを持てる' do
        user = create(:user)
        recipe1 = create(:recipe, user: user)
        recipe2 = create(:recipe, user: user)
        expect(user.recipes).to include(recipe1, recipe2)
      end

      it 'ユーザーを削除すると関連レシピも削除される' do
        user = create(:user)
        create(:recipe, user: user)
        expect { user.destroy }.to change { Recipe.count }.by(-1)
      end
    end

    context 'ショッピングリストの場合' do
      it { should have_many(:shopping_lists).dependent(:destroy) }
      it '複数のショッピングリストを持てる' do
        user = create(:user)
        shopping_list1 = create(:shopping_list, user: user)
        shopping_list2 = create(:shopping_list, user: user)
        expect(user.shopping_lists).to include(shopping_list1, shopping_list2)
      end

      it 'ユーザーを削除すると関連のショッピングリストも削除される' do
        user = create(:user)
        create(:shopping_list, user: user)
        expect { user.destroy }.to change { ShoppingList.count }.by(-1)
      end
    end
  end

  describe '認証メソッド' do
    let(:user) { create(:user, password: 'password123') }

    describe '#authenticate' do
      it '正しいパスワードで認証成功' do
        expect(user.authenticate('password123')).to eq(user)
      end

      it '間違ったパスワードで認証失敗' do
        expect(user.authenticate('misspassword')).to be false
      end

      it 'nilパスワードで認証失敗' do
        expect(user.authenticate(nil)).to be false
      end
    end

    describe 'password_digest' do
      it 'パスワードが暗号化されて保存される' do
        expect(user.password_digest).to be_present
        expect(user.password_digest).not_to eq('password123')
      end
    end
  end

  describe 'Google認証' do
    describe 'password_required?メソッド' do
      context 'google_uidがない場合' do
        let(:user) { build(:user, google_uid: nil) }

        it '新規レコードでパスワードは必須' do
          expect(user.send(:password_required?)).to be true
        end

        it '既存レコードでパスワード変更時は必須' do
          user.save!
          user.password = 'newpassword'
          expect(user.send(:password_required?)).to be true
        end
      end

      context 'google_uidがある場合' do
        let(:google_user) { create(:google_user) }

        it 'パスワード不要' do
          expect(google_user.send(:password_required?)).to be false
        end
      end
    end
  end

  describe 'エッジケース' do
    it 'メールアドレス大文字小文字の扱い' do
      create(:user, email: 'Test@Example.com')
      user2 = build(:user, email: 'test@example.com')
      expect(user2).to be_valid
    end
  end
end
