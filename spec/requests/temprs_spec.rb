# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Temprs', type: :request do
  describe 'GET /api/v1/device_groups/:device_group_id/temprs' do
    let(:device_group) { FactoryBot.create(:device_group) }

    it 'works! (now write some real specs)' do
      get api_v1_device_group_temprs_path(device_group), headers: { Authorization: JsonWebToken.encode(user_id: FactoryBot.create(:user).id) }
      expect(response).to have_http_status(200)
    end
  end
end
