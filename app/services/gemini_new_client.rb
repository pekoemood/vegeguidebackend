class GeminiNewClient 
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"


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
    #{vegetable_names}を使用したレシピを1つ日本語で出力してください。  
      
    制約条件：  
    - "servings" は数値で、指定された#{@servings}人分にしてください。調理量や材料の分量もそれに合わせて調整してください。
    - "instructions" は、出力したレシピの簡単な概要を説明する文章にしてください。
    - "category" はユーザー指定の#{recipe_category}にしてください。料理のジャンルや特徴に合う内容にしてください。  
    - calorie は指定された#{@calorie}kcal以下になるよう、材料と分量から計算してください。計算は以下の例を参考にして行い、実際の材料の重さや量をもとに正確に見積もってください。指定値そのものをそのまま出力しないでください。
      - 【カロリー計算例】
          豚バラ肉 100g = 約 364kcal
          白菜 100g = 約 13kcal
          砂糖 小さじ1（約3g）= 約 12kcal
          醤油 小さじ1（約5ml）= 約 5kcal
          みりん 小さじ1（約5ml）= 約 15kcal
          サラダ油 小さじ1（約5ml）= 約 45kcal
      - 材料ごとに分量を基準にカロリーを算出すること。  
      - 小数点以下も考慮し、適切に四捨五入してください。  
      - 「servings」に応じて材料の分量を調整し、カロリーも比例して計算してください。  
      - 出力するカロリーは、実際に計算した合計値を整数で示してください。  
      - ただし、指定された#{@calorie}kcalを超えないように調整してください。  
      - 指定のカロリー値そのものは出力せず、材料と分量に基づく実際の計算結果のみを記載してください。 
    - "difficulty" はユーザー指定の#{@difficulty}を反映してください。調理手順の複雑さや技術レベルが一致するようにしてください。  
    - "cooking_method" はユーザー指定の#{@cooking_method}にしてください。調理方法に沿った手順や調理器具を使ってください。  
    - "cooking_time" は「#{@cooking_time}」を参考にしつつ、実際の材料・手順に即した現実的な調理時間（分）を数値で出力してください。指定された数値そのものを出力しないでください。 
    - 材料の "amount" と "unit" は以下のルールに従ってください：
      - 数量が数値で "unit" が単位になるように出力してください（例：amount: 3, unit: "大さじ"）
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

  TEXT
end

  def generate_recipe
    options = {
      query: { key: @api_key },
      headers: { 'Content-Type' => 'application/json' },
      body: {
  "system_instruction": {
    "parts": [
      {
        "text": "あなたは一流のシェフです。ユーザーの要望に基づき、家庭でも作りやすく、かつプロの味を感じさせるような、健康的で美味しいレシピを考案してください。レシピ名、カテゴリ、総合的な手順、カロリー、調理法、調理時間、難易度、分量を明確に示してください。材料リストは、名称、量、単位、表示量、カテゴリを詳細に記述してください。過度に複雑な手順や特殊な食材は避け、実践的なレシピを作成してください。"
      }
    ]
  },     
  "contents": [{
    "parts": [
      {
        "text": @text
      }
    ]
  }],
  "generationConfig": {
    "responseMimeType": "application/json",
    "responseSchema": {
      "type": "ARRAY",
      "items": {
        "type": "OBJECT",
        "properties": {
          "name": { "type": "STRING" },
          "recipe_category": { "type": "STRING" },
          "instructions": { "type": "STRING" },
          "calorie": { "type": "INTEGER" },
          "cooking_method": { "type": "STRING" },
          "cooking_time": { "type": "INTEGER" },
          "difficulty": { "type": "STRING" },
          "servings": { "type": "INTEGER" },
          "step": {
            "type": "ARRAY",
            "items": {
              "type": "OBJECT",
              "properties": {
                "step_number": { "type": "INTEGER" },
                "description": { "type": "STRING" }
              },
              "propertyOrdering": ["step_number", "description"]
            }
          },
          "ingredients": {
            "type": "ARRAY",
            "items": {
              "type": "OBJECT",
              "properties": {
                "name": { "type": "STRING" },
                "amount": {
                  "oneOf": [
                    { "type": "INTEGER" },
                    { "type": "NULL" }
                  ]
                },
                "unit": { "type": "STRING" },
                "display_amount": { "type": "STRING" },
                "category": { "type": "STRING" }
              },
              "propertyOrdering": ["name", "amount", "unit", "display_amount", "category"]
            }
          }
        },
        "propertyOrdering": ["name", "recipe_category", "instructions", "calorie", "cooking_method", "cooking_time", "difficulty", "servings", "step", "ingredients"]
      }
    }
  }
}.to_json
    }

    response = self.class.post("", options).parsed_response
    Rails.logger.info("Gemini API response: #{response}")
    text_block = response["candidates"][0]["content"]["parts"][0]["text"]
    text = text_block rescue "{}"
    return text
  end
end