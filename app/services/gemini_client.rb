class GeminiClient 
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"


def initialize(vegetable='キャベツ', servings=2, recipe_category='主菜', difficulty='簡単', cooking_time_category='short')
  @api_key = Rails.application.credentials.dig(:gemini, :api_key)

  # 調理時間カテゴリーを具体的な指示に変換
  cooking_time_prompt = case cooking_time_category
  when 'short'
    '15分以内の調理時間'
  when 'medium'
    '16分から30分以内の調理時間'
  when 'long'
    '30分以上の調理時間'
  else
    '15分以内の調理時間'
  end

  @text = <<~TEXT
    #{vegetable}を使用したレシピを1つ、以下のJSON形式で出力してください。  
    出力は日本語で、JSON以外の説明は含めないでください。  
    JSON構造は厳密に以下に従ってください。  

    制約条件：  
    - "servings" は数値で、指定された#{servings}人分にしてください。  
    - "category" は以下のレシピカテゴリ一覧から選び、必ず#{recipe_category}にしてください。  
    - "difficulty" はユーザー指定の#{difficulty}を反映してください。  
    - "cooking_time" はユーザーが選択した調理時間のカテゴリ「#{cooking_time_prompt}」に基づき、調理にかかる実際の時間（分）を数値（Number型）で出力してください。  
    - "image_url" を必ず含めてください。仮のURLでも構いません。  
    - 材料それぞれに、以下の材料カテゴリ一覧から1つの"category"を指定してください。   

    レシピカテゴリ一覧（レシピ全体）：  
    - 主菜  
    - 副菜  
    - スープ  
    - サラダ  
    - ご飯もの  
    - 麺類  
    - おやつ  

    材料カテゴリ一覧（材料ごと）：  
    - 野菜  
    - 肉類  
    - 魚介類  
    - 卵・乳製品  
    - 豆・豆製品  
    - 穀類・パン  
    - 調味料  
    - 加工食品  
    - その他  

    以下の形式で出力してください:  

    ```json
    {
      "name": "レシピ名",
      "category": "#{recipe_category}",
      "image_url": "https://example.com/sample.jpg",
      "instructions": "レシピの簡単な説明",
      "cooking_time": "#{cooking_time_prompt}",
      "difficulty": "#{difficulty}",
      "servings": #{servings},
      "step": [
        {
          "step_number": 1,
          "description": "材料を切る"
        },
        {
          "step_number": 2,
          "description": "炒める"
        }
      ],
      "ingredients": [
        {
          "name": "にんじん",
          "amount": 1,
          "unit": "本",
          "category": "野菜"
        }
      ]
    }
    ```
  TEXT
end

  def generate_recipe
    options = {
      query: { key: @api_key },
      headers: { 'Content-Type' => 'application/json' },
      body: {
        contents: [
          {
            parts: [
              { text: @text }
            ]
          }
        ]
      }.to_json
    }

    response = self.class.post("", options).parsed_response
    Rails.logger.info("Gemini API response: #{response}")
    text_block = response["candidates"][0]["content"]["parts"][0]["text"]
    text = text_block.match(/```json\n(.*)\n```/m)[1] rescue "{}"
    return text
  end
end