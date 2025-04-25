class GeminiClient 
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"


  def initialize(vegetable='キャベツ')
    @api_key = Rails.application.credentials.dig(:gemini, :api_key)
    @text = <<~TEXT
        #{vegetable}を使用したレシピを１つ、以下のJSON形式で出力してください。
        出力は日本語で、以下のJSONk構造に厳密に従ってください。JSON以外の説明文などは含めないでください。
        ```json
        {
          "name": "レシピ名",
          "instructions": "レシピの簡単な説明",
          "cooking_time": "調理時間",
          "difficulty": "調理の難易度",
          "step": [
                    {
                    "step_number": "手順の番号",
                    "description": "調理手順"
                    }
                  ],
          "ingredients":  [
                            {
                              "name": "材料名",
                              "amount": "量",
                              "unit": "単位"
                            }
                          ] 

        }
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
    text_block = response["candidates"][0]["content"]["parts"][0]["text"]
    text = text_block.match(/```json\n(.*)\n```/m)[1] rescue "{}"
    return text
  end
end