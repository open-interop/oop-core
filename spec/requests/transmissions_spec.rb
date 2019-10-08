# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Transmissions', type: :request do
  describe 'GET /api/v1/devices/:id/transmissions' do
    let(:device) { FactoryBot.create(:device) }
    let(:account) { Account.first }
    let(:api_user) { FactoryBot.create(:user, account: account) }

    before do
      allow_any_instance_of(Device).to(
        receive(:bunny_connection).and_return(BunnyMock.new.start)
      )
    end

    let!(:transmissions) do
      Array.new(10) do
        FactoryBot.create(:transmission, device: device)
      end
    end

    before do
      get(api_v1_device_transmissions_path(device), headers: { Authorization: JsonWebToken.encode(user_id: api_user.id) })
    end

    let(:json_body) { JSON.parse(response.body) }

    it { expect(response).to have_http_status(200) }
    it do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it { expect(json_body['totalRecords']).to eq(10) }
    it { expect(json_body['numberOfPages']).to eq(1) }
    it { expect(json_body['page']['number']).to eq(1) }
    it { expect(json_body['page']['size']).to eq(10) }
    it { expect(json_body['data'].size).to eq(10) }

    describe 'matches the latest transmission' do
      it { expect(json_body['data'][0]['id']).to eq(transmissions.last.id) }
      it { expect(json_body['data'][0]['deviceTemprId']).to eq(transmissions.last.device_tempr_id) }
      it { expect(json_body['data'][0]['messageUuid']).to eq(transmissions.last.message_uuid) }
      it { expect(json_body['data'][0]['transmissionUuid']).to eq(transmissions.last.transmission_uuid) }
      it { expect(json_body['data'][0]['success']).to eq(transmissions.last.success) }
      it { expect(json_body['data'][0]['status']).to eq(transmissions.last.status) }
      it { expect(json_body['data'][0]['transmittedAt']).to eq(transmissions.last.transmitted_at.as_json) }
      it { expect(json_body['data'][0]['body']).to eq(transmissions.last.body) }
    end
  end
end
