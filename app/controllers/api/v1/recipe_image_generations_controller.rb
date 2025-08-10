class Api::V1::RecipeImageGenerationsController < ApplicationController
  before_action :authenticate_user!

  def create
    gemini =GeminiImageClient.new(params.require(:recipe).permit(:name, ingredients: [:name, :amount, :unit, :display_amount, :category]))
    base64_image = gemini.generate_recipe_image

    unless base64_image
      return render json: {error: "画像生成に失敗しました" }, status: :unprocessable_entity
    end

    decode = Base64.decode64(base64_image)

    file = Tempfile.new(['recipe_image', '.png'])
    file.binmode
    file.write(decode)
    file.rewind

    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: 'generated.png', content_type: 'image/png')

    render json: { image_id: blob.signed_id, image_url: blob.url }
  end
end
