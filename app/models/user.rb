class User < ApplicationRecord
  has_secure_password
  has_many :recipes, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :fridge_items, dependent: :destroy
  validates :name, presence: { message: '名前の入力は必須です' }
  validates :email, presence: { message: 'メールアドレスの入力は必須です'}, uniqueness: { message: 'このメールアドレスはすでに使用されています'}, format: { with: URI::MailTo::EMAIL_REGEXP, message: '無効なメールアドレスです' } 
  validates :password, presence: { message: 'パスワードの入力は必須です'}, length: { minimum: 8, message: '8文字以上で入力してください' }, if: :password_required?

  private

  def password_required?
    google_uid.blank? && (new_record? || !password.nil?)
  end
end
