class TempImage < ApplicationRecord
  has_one_attached :image

  before_destroy :purge_image

  private

  def purge_image
    image.purge if image.attached?
  end
end
