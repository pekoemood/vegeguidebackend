class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :recipe_steps, dependent: :destroy
  has_many :shopping_list_items, dependent: :destroy
  has_many :shopping_lists, through: :shopping_list_items
  has_one_attached :image
  before_destroy :purge_image

  private

  def purge_image
    image.purge_later if image.attached?
  end
end
