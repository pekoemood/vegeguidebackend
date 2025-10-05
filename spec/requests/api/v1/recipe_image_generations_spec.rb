require 'rails_helper'

RSpec.describe "Api::V1::RecipeImageGenerations", type: :request do
  describe "POST /api/v1/recipe_image_generations" do
    let(:user) { create(:user) }
    let(:request) { { recipe:
    { name: '野菜炒め',
      ingredients: [ { name: 'キャベツ', amount: '200', unit: 'g', display_amount: '200g', category: '野菜' },
                    { name: '豚肉', amount: '200', unit: 'g', display_amount: '200g', category: '肉類' }
                    ] } } }
    before { login user }
    context '正常系' do
      let(:mock_base64_image) { "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==" }
      let(:mock_blob) { instance_double(ActiveStorage::Blob, signed_id: 'mock_signed_id_123', url: 'https://localhost:3000/rails/active_storage/blobs/mock_url') }
      before do
        gemini_image_client = instance_double(GeminiImageClient)
        allow(GeminiImageClient).to receive(:new).with(any_args).and_return(gemini_image_client)
        allow(gemini_image_client).to receive(:generate_recipe_image).and_return(mock_base64_image)
        allow(ActiveStorage::Blob).to receive(:create_and_upload!).and_return(mock_blob)
      end

      it '正しいリクエストならイメージ画像とIDをレスポンスすること' do
        post '/api/v1/recipe_image_generations', params: request
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        puts json
        expect(json['image_id']).to eq(mock_blob.signed_id)
        expect(json['image_url']).to eq(mock_blob.url)
      end
    end

    context '異常系' do
      let(:mock_base64_image) { nil }
      before do
        gemini_image_client = instance_double(GeminiImageClient)
        allow(GeminiImageClient).to receive(:new).and_return(gemini_image_client)
        allow(gemini_image_client).to receive(:generate_recipe_image).and_return(mock_base64_image)
      end
      it 'base64imageがない場合はエラーを返すこと' do
        post "/api/v1/recipe_image_generations", params: request
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('画像生成に失敗しました')
      end
    end
  end
end
