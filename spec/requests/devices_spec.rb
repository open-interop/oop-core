# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Devices", type: :request do
  describe "GET /api/v1/devices" do
    it "works! (now write some real specs)" do
      get [:api, :v1, :devices]
      expect(response).to have_http_status(200)
    end
  end
end
