class GeminiImageClient
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent"

  def initialize(params = {})
    @api_key = Rails.application.credentials.dig(:gemini, :api_key)

    name = params["name"] || '野菜いため'
    ingredients = params["ingredients"] || ["キャベツ", "ピーマン", "豚肉"]
    main_ingredients = ingredients.select { |i| i["category"] != '調味料' }
    ingredients_text = main_ingredients.map { |i| i["name"] }.join(", ")

    @text = <<~TEXT
Create a realistic, high-resolution food photograph of the dish #{name}, plated in a classic center-framing (日の丸構図) from a top-down or slight 45° angle.
Serve it on a clean white plate with #{ingredients_text}, placed on a light wooden table with soft natural window light.
The image should capture glossy sauce, gentle steam, vibrant color contrast, and natural shadows.
Add a touch of everyday kitchen style by including a linen napkin and simple cutlery at the edge of the frame.
Do not include any text, typography, labels, logos, or signage in the image.
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
        "generationConfig": { 
          "responseModalities": ["TEXT","IMAGE" ]}
        }.to_json
    }

    response = self.class.post("", options).parsed_response
    
    parts = response.dig("candidates", 0, "content", "parts") || []
    image_data = parts.find { |p| p["inlineData"] }&.dig("inlineData", "data")


    Rails.logger.debug(@text)
    
    
    Rails.logger.warn("GeminiImageClient: 画像データが取得できませんでした") unless image_data
    
    image_data
  end
end