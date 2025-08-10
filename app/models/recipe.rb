class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients
  has_many :recipe_steps, dependent: :destroy
  has_many :shopping_list_items
  has_many :shopping_lists, through: :shopping_list_items
  has_one_attached :image
  before_destroy :purge_image

  def image_url
    image.attached? ? image.url : nil
  end
  
  private

  def purge_image
    image.purge_later if image.attached?
  end


end
