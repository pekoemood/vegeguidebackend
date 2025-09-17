require 'rails_helper'

RSpec.describe GeminiNewClient do
  describe '#generate_recipe' do
    let(:params) do
      {
        'cookingTime' => '30',
        'calorie' => '400',
        'category' => '和食',
        'purpose' => 'ダイエット',
        'servings' => '2',
        'cookingMethod' => 'フライパン',
        'selectedVegetables' => ['にんじん', 'ピーマン']
      }
    end

    let(:client) { described_class.new(params) }

    it 'Gemini APIからレシピを取得する' do
      fake_response = {
        'candidates' => [
          {
            'content' => {
              'parts' => [
                { 'text' => 'これはモックされたレシピです' }
              ]
            }
          }
        ]
      }

      allow(GeminiNewClient).to receive(:post).and_return(double(parsed_response: fake_response))

      result = client.generate_recipe
      expect(result).to eq('これはモックされたレシピです')
    end
  end
end

