require 'rails_helper'

RSpec.describe "HealthChecks", type: :request do
  describe "GET /health" do
    it "returns http success" do
      get "/health_check/health"
      expect(response).to have_http_status(:success)
    end
  end

end
