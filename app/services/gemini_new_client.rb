class GeminiNewClient 
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"


def initialize(params)
  @api_key = Rails.application.credentials.dig(:gemini, :api_key)

  @cooking_time = params["cookingTime"]
  @calorie = params["calorie"]
  @category = params["category"]
  @purpose = params["purpose"] || '指定なし'
  @servings = params["servings"]
  @cooking_method = params["cookingMethod"]
  @selected_vegetables = params["selectedVegetables"]

  vegetable_names = @selected_vegetables.join(", ")
  recipe_category = @category

  calorie_instruction = ""
  if @calorie == '400'
    calorie_instruction = "400kcalを超えないように食材と分量を調整し、レシピを生成してください。"
  elsif @calorie == '700'
    calorie_instruction = "700kcalを超えないように食材と分量を調整し、レシピを生成してください。"
  elsif @calorie == '9999'
    calorie_instruction = "700kcal以上になるように食材と分量を調整し、高カロリーなレシピを生成してください。上限は特に指定しません。"
  else
    calorie_instruction = "レシピの合計カロリーを食材と分量から見積もって整数で出力してください。"
  end

  @text = <<~TEXT
    #{vegetable_names}を使用したレシピを1つ日本語で出力してください。  
      
    制約条件：  
    - "servings" は数値で、指定された#{@servings}人分にしてください。調理量や食材の分量もそれに合わせて調整してください。
    - "instructions" は、出力したレシピの簡単な概要を説明する文章にしてください。
    - "category" はユーザー指定の#{recipe_category}にしてください。料理のジャンルや特徴に合う内容にしてください。  
    - "calorie" は、提供するレシピの合計カロリー（食材と分量から見積もられる値）を整数で出力してください。その際、#{calorie_instruction}
      - 【カロリー算出の目安として以下を参考にしてください】
          豚バラ肉 100g = 約 364kcal
          白菜 100g = 約 13kcal
          砂糖 小さじ1（約3g）= 約 12kcal
          醤油 小さじ1（約5ml）= 約 5kcal
          みりん 小さじ1（約5ml）= 約 15kcal
          サラダ油 小さじ1（約5ml）= 約 45kcal
      - 「servings」に応じて食材の分量を調整してください。
    - "purpose" はユーザー指定の「#{@purpose}」を考慮し、その目的に合ったレシピを生成してください。 
    - "cooking_method" はユーザー指定の#{@cooking_method}にしてください。調理方法に沿った手順や調理器具を使ってください。  
    - "cooking_time" は「#{@cooking_time}」を参考にしつつ、実際の食材・手順に即した現実的な調理時間（分）を数値で出力してください。指定された数値そのものを出力しないでください。 
    - "step" は、調理手順を具体的なステップ番号と、その説明を記述した"description"で構成される配列として出力してください。各ステップは順番に並べ、家庭で再現しやすいように簡潔かつ具体的に記述してください。
    - 食材の "amount" と "unit" は以下のルールに従ってください：
      - 数量が数値で "unit" が単位になるように出力してください（例：amount: 3, unit: "大さじ"）
      - 小数（例：0.25個）は分数に直して、自然な日本語表記にしてください（例：1/4個、1/2本 など）
      - unit に「少々」や「適量」が必要な場合は、"amount" を null にし、"unit": "少々" のようにしてください
      - 日本語として自然な表示用に "display_amount"（例："大さじ2", "1/2本", "少々"）も出力してください。
    - 食材はそれぞれに、以下の食材カテゴリ一覧から1つの"category"を指定してください。     

    食材カテゴリ一覧（食材ごと）：  
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
        "text": "あなたは一流のシェフです。ユーザーの要望に基づき、家庭でも作りやすく、かつプロの味を感じさせるような、健康的で美味しいレシピを考案してください。レシピ名、カテゴリ、総合的な手順、カロリー、調理法、調理時間、難易度、分量を明確に示してください。食材リストは、名称、量、単位、表示量、カテゴリを詳細に記述してください。過度に複雑な手順や特殊な食材は避け、実践的なレシピを作成してください。"
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
          "purpose": { "type": "STRING" },
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
        "propertyOrdering": ["name", "recipe_category", "instructions", "calorie", "cooking_method", "cooking_time", "purpose", "servings", "step", "ingredients"]
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