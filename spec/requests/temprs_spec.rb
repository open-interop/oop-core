require 'rails_helper'

RSpec.describe "Temprs", type: :request do
  describe "GET /temprs" do
    it "works! (now write some real specs)" do
      get temprs_path
      expect(response).to have_http_status(200)
    end
  end
end
