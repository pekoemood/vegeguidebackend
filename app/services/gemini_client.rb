class GeminiClient 
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"


  def initialize(vegetable='キャベツ')
    @api_key = Rails.application.credentials.dig(:gemini, :api_key)
    @text = "#{vegetable}のレシピを出力して"
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

    response = self.class.post("", options)
    return response
  end
end