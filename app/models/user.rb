class User < ApplicationRecord
  has_secure_password
  has_many :recipes
  has_many :shopping_lists
  validates :name, presence: { message: '名前の入力は必須です' }
  validates :email, presence: { message: 'メールアドレスの入力は必須です'}, uniqueness: { message: 'このメールアドレスはすでに使用されています'}, format: { with: URI::MailTo::EMAIL_REGEXP, message: '無効なメールアドレスです' } 
  validates :password, presence: { message: 'パスワードの入力は必須です'}, length: { minimum: 8, message: '８文字以上で入力してください' }
end
