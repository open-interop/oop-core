require 'rails_helper'

RSpec.describe 'API::V1::DeviceTemprs', type: :request do
  describe 'GET /api/v1/devices/1/device_temprs' do
    let(:device) { FactoryBot.create(:device) }

    it 'works! (now write some real specs)' do
      get api_v1_device_device_temprs_path(device.id), headers: { Authorization: JsonWebToken.encode(user_id: FactoryBot.create(:user).id) }
      expect(response).to have_http_status(200)
    end
  end
end
