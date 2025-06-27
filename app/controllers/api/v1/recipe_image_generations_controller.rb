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

    temp_image = TempImage.new
    temp_image.image.attach(io: file, filename: 'generated.png', content_type: 'image/png')
    temp_image.save!

    render json: { temp_image_id: temp_image.id, image_url: rails_blob_url(temp_image.image, host:"localhost:3000")}

  end
end
