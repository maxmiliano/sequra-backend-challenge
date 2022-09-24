require 'rails_helper'

RSpec.describe "Disbursements", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/disbursement/index"
      expect(response).to have_http_status(:success)
    end
  end

end
