# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Dashboards', type: :request do
  let(:device) { FactoryBot.create(:device) }

  let(:device_two) do
    FactoryBot.create(:device, authentication_path: '/path-2')
  end

  let(:account) { Account.first }
  let(:api_user) { FactoryBot.create(:user, account: account) }
  let(:authorization_headers) do
    {
      Authorization: JsonWebToken.encode(user_id: api_user.id)
    }
  end

  let!(:transmissions) do
    Array.new(3) do
      FactoryBot.create(:transmission, device: device, success: true)
    end +
      Array.new(2) do
        FactoryBot.create(:transmission, device: device, success: false)
      end +
      Array.new(2) do
        FactoryBot.create(:transmission, device: device_two, success: true)
      end +
      Array.new(2) do
        FactoryBot.create(:transmission, device: device_two, success: false)
      end
  end

  describe 'GET /api/v1/dashboards/transmissions' do
    let(:device) { FactoryBot.create(:device) }

    context 'group by device_id' do
      before do
        get(
          api_v1_dashboards_transmissions_path(device_id: device, group: 'device_id'),
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['transmissions'][device.id.to_s]).to eq(5) }
        it { expect(json_body['group']).to eq('device_id') }
      end
    end

    context 'group by success' do
      before do
        get(
          api_v1_dashboards_transmissions_path(device_id: device, group: 'success'),
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['transmissions']['true']).to eq(3) }
        it { expect(json_body['transmissions']['false']).to eq(2) }
        it { expect(json_body['group']).to eq('success') }
      end
    end

    context 'group by transmitted_at' do
      before do
        get(
          api_v1_dashboards_transmissions_path(device_id: device, group: 'transmitted_at'),
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['transmissions'][Time.now.to_date.to_s]).to eq(5) }
        it { expect(json_body['group']).to eq('transmitted_at') }
      end
    end

    context 'all devices' do
      context 'group by device_id' do
        before do
          get(
            api_v1_dashboards_transmissions_path(group: 'device_id'),
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['transmissions'][device.id.to_s]).to eq(5) }
          it { expect(json_body['transmissions'][device_two.id.to_s]).to eq(4) }
          it { expect(json_body['group']).to eq('device_id') }
        end
      end

      context 'group by success' do
        before do
          get(
            api_v1_dashboards_transmissions_path(group: 'success'),
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['transmissions']['true']).to eq(5) }
          it { expect(json_body['transmissions']['false']).to eq(4) }
          it { expect(json_body['group']).to eq('success') }
        end
      end

      context 'group by transmitted_at' do
        before do
          get(
            api_v1_dashboards_transmissions_path(group: 'transmitted_at'),
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['transmissions'][Time.now.to_date.to_s]).to eq(9) }
          it { expect(json_body['group']).to eq('transmitted_at') }
        end
      end
    end
  end
end
