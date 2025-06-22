class GeminiImageClient
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent"

  def initialize(params = {})
    @api_key = Rails.application.credentials.dig(:gemini, :api_key)

    @name = params["name"] || '野菜いため'
    @step = params["step"] || ["野菜を切る", "野菜を炒める", "お皿に盛って完成"]
    @ingredients = params["ingredients"] || ["キャベツ", "ピーマン", "豚肉"]
    @style = "上からの自然光で撮影されたプロっぽい写真"

    @text = <<~TEXT
      #{@name}の料理画像を出力してください。

      制約条件：
      - 画像生成の際に次の調理手順を参考にしてください。#{@step}
      - 画像には次の材料を全て含めてください。#{@ingredients}
      - 生成する画像は#{@style}にしてください。

    TEXT
  end

  def generate_recipe_image
    options = {
      query: { key: @api_key },
      headers: { 'Content-Type' => 'application/json' },
      body: {
        "contents": [{
          "parts": [
            { "text": @text }
          ]
        }],
        "generationConfig": { "responseModalities": ["TEXT","IMAGE" ]}
        }.to_json
    }

    response = self.class.post("", options).parsed_response
    image = response["candidates"][0]["content"]["parts"][1]["inlineData"]["data"]
    
    Rails.logger.warn("GeminiImageClient: 画像データが取得できませんでした") unless image
    
    image
  end
end