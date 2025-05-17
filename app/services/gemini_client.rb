class GeminiClient 
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"


def initialize(params)
  @api_key = Rails.application.credentials.dig(:gemini, :api_key)

  @cooking_time = params["cookingTime"]
  @calorie = params["calorie"]
  @category = params["category"]
  @difficulty = params["difficulty"]
  @servings = params["servings"]
  @cooking_method = params["cookingMethod"]
  @selected_vegetables = params["selectedVegetables"]

  vegetable_names = @selected_vegetables.join(", ")
  recipe_category = @category

  @text = <<~TEXT
    #{vegetable_names}を使用したレシピを1つ、以下のJSON形式で出力してください。  
    出力は日本語で、JSON以外の説明は含めないでください。  
    JSON構造は厳密に以下に従ってください。  

    制約条件：  
    - "servings" は数値で、指定された#{@servings}人分にしてください。調理量や材料の分量もそれに合わせて調整してください。  
    - "category" はユーザー指定の#{recipe_category}にしてください。料理のジャンルや特徴に合う内容にしてください。  
    - "calorie" は目安として#{@calorie} kcalを参考にし、実際の材料の種類や分量をもとにレシピ全体のカロリーを見積もって記載してください。指定の数値そのものを出力しないでください。  
    - "difficulty" はユーザー指定の#{@difficulty}を反映してください。調理手順の複雑さや技術レベルが一致するようにしてください。  
    - "cooking_method" はユーザー指定の#{@cooking_method}にしてください。調理方法に沿った手順や調理器具を使ってください。  
    - "cooking_time" は「#{@cooking_time}」を参考にしつつ、実際の材料・手順に即した現実的な調理時間（分）を数値で出力してください。指定された数値そのものを出力しないでください。 
    - 材料の "amount" と "unit" は以下のルールに従ってください：
      - 数量が数値で "unit" が単位になるように出力してください（例：amount: 3, unit: "大さじ"）
      - "unit" の方を後にせず、数値を先にして記述すること（例：正：大さじ3 → amount: 3, unit: "大さじ"／誤：3 大さじ）
      - 小数（例：0.25個）は分数に直して、自然な日本語表記にしてください（例：1/4個、1/2本 など）
      - unit に「少々」や「適量」が必要な場合は、"amount" を null にし、"unit": "少々" のようにしてください
      - 日本語として自然な表示用に "display_amount"（例："大さじ2", "1/2本", "少々"）も出力してください。
    - 材料それぞれに、以下の材料カテゴリ一覧から1つの"category"を指定してください。     

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
      "recipe_category": "#{recipe_category}",
      "instructions": "レシピの簡単な説明",
      "calorie": #{@calorie},
      "cooking_method": "#{@cooking_method}",
      "cooking_time": #{@cooking_time},
      "difficulty": "#{@difficulty}",
      "servings": #{@servings},
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
          "display_amount": "１本"
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