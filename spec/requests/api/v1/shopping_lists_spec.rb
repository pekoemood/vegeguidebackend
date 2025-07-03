require 'rails_helper'

RSpec.describe "Api::V1::ShoppingLists", type: :request do
  describe "GET /api/v1/shopping_lists" do
    it "works! (now write some real specs)" do
      get api_v1_shopping_lists_index_path
      expect(response).to have_http_status(200)
    end
  end
end
