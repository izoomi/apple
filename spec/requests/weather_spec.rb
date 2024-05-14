require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /search" do
    it "returns http not found" do
      get "/weather/search"
      expect(response).to have_http_status(:success)
    end
  end
end
