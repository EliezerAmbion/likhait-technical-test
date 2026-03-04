require 'rails_helper'

RSpec.describe "Api::Categories", type: :request do
  describe "GET /api/categories" do
    it "returns a list of categories" do
      Category.create!(name: "Food")
      Category.create!(name: "Transport")

      get "/api/categories"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
      expect(json.map { |c| c["name"] }).to include("Food", "Transport")
    end
  end

  describe "POST /api/categories" do
    context "with valid params" do
      it "creates a new category" do
        expect {
          post "/api/categories", params: { category: { name: "Health" } }
        }.to change(Category, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Health")
      end
    end

    context "with invalid params" do
      it "returns errors when name is blank" do
        post "/api/categories", params: { category: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end
  end
end
