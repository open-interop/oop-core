# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sites', type: :request do
  describe 'GET /api/v1/sites' do
    it 'works! (now write some real specs)' do
      get api_v1_sites_path, headers: { Authorization: JsonWebToken.encode(user_id: FactoryBot.create(:user).id) }
      expect(response).to have_http_status(200)
    end
  end
end
