class EmailChangeRequest < ApplicationRecord
  belongs_to :user

  validates :new_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true

  def expired?
    expires_at < Time.current
  end
end
