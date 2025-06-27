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
      Create a highly realistic, high-resolution food photograph featuring the dish #{name}.
      The plating should be classic **center-framed (日の丸構図)**, with the dish prominently positioned in the middle, shot from a **top-down or a slight 45-degree angle**.

      Serve the dish on a **clean, minimalist white plate** with **#{ingredients_text}**.
      The setup is on a **light, natural wood table**, bathed in **soft, diffused natural window light** creating subtle, natural shadows.

      The image must capture a **rich, glossy sauce**, **delicate, wispy steam**, **vibrant color contrast**, and authentic textures.
      To add an everyday kitchen aesthetic, include a **neatly folded linen napkin** and **simple, elegant cutlery** subtly placed at the very edge of the frame, hinting at a casual setting.

      **Exclude all text, typography, labels, logos, or signage from the image.**
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