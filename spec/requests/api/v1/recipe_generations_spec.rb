require 'rails_helper'

RSpec.describe "Api::V1::RecipeGenerations", type: :request do
  describe "POST /api/v1/recipe_generations" do
    let(:user) { create(:user) }
    let(:request_data) { { recipe_generation: 
                      { cookingTime: 5, 
                        calorie: 600, 
                        category: '野菜', 
                        purpose: '指定なし', 
                        servings: 2, 
                        cookingMethod: 'フライパン', 
                        selectedVegetables: ['だいこん', '人参'] }} }
    let(:mock_response) {
      {
        "name" => "大根とにんじんの炒め物",
        "recipe_category" => "野菜",
        "instructions" => "シンプルな野菜炒めのレシピです",
        "calorie" => 600,
        "cooking_method" => "フライパン",
        "cooking_time" => 15,
        "purpose" => "指定なし",
        "servings" => 2,
        "step" => [
          { "step_number" => 1, "description" => "野菜を切る" },
          { "step_number" => 2, "description" => "フライパンで炒める" }
        ],
        "ingredients" => [
          {
            "name" => "だいこん",
            "amount" => 1,
            "unit" => "本",
            "display_amount" => "1本",
            "category" => "野菜"
          },
          {
            "name" => "にんじん",
            "amount" => 1,
            "unit" => "本",
            "display_amount" => "1本",
            "category" => "野菜"
          }
        ]
      }.to_json
    }
    before do
      login user
      gemini_client_mock = instance_double(GeminiNewClient)
      allow(GeminiNewClient).to receive(:new).with(any_args).and_return(gemini_client_mock)
      allow(gemini_client_mock).to receive(:generate_recipe).and_return(mock_response)
    end
    context '正常系' do
      it '正しいリクエストにはレスポンスを返す' do
        post '/api/v1/recipe_generations', params: request_data
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
