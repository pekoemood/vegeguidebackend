require "test_helper"

class Api::V1::RecipeGenerationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_recipe_generations_create_url
    assert_response :success
  end
end
