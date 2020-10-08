# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Dashboards', type: :request do
  let!(:account) { Account.first }

  let(:device) { FactoryBot.create(:device, account: account) }

  let(:device_two) do
    FactoryBot.create(:device, account: account, authentication_path: '/path-2')
  end

  let(:api_user) { FactoryBot.create(:user, account: account) }
  let(:authorization_headers) do
    {
      Authorization: JsonWebToken.encode(user_id: api_user.id)
    }
  end

  describe 'GET /api/v1/dashboards/transmissions' do
    let!(:transmissions) do
      Array.new(3) do
        FactoryBot.create(
          :transmission,
          account: account,
          device: device,
          success: true,
          status: 200,
          transmitted_at: '2019-11-24'
        )
      end +
        Array.new(2) do
          FactoryBot.create(
            :transmission,
            account: account,
            device: device,
            success: false,
            status: 400,
            transmitted_at: '2019-11-21'
          )
        end +
        Array.new(2) do
          FactoryBot.create(
            :transmission,
            account: account,
            device: device_two,
            success: true,
            status: 201,
            transmitted_at: '2019-11-24'
          )
        end +
        Array.new(2) do
          FactoryBot.create(
            :transmission,
            account: account,
            device: device_two,
            success: false,
            status: 401,
            transmitted_at: '2019-11-21'
          )
        end
    end

    context 'group by device_id' do
      before do
        get(
          api_v1_dashboards_transmissions_path,
          params: { filter: { device_id: device.id }, group: 'device_id' },
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
          api_v1_dashboards_transmissions_path,
          params: { filter: { device_id: device.id }, group: 'success' },
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
          api_v1_dashboards_transmissions_path,
          params: { filter: { device_id: device.id }, group: 'transmitted_at' },
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['transmissions']['2019-11-21']).to eq(2) }
        it { expect(json_body['group']).to eq('transmitted_at') }
      end
    end

    context 'all devices' do
      context 'group by device_id' do
        before do
          get(
            api_v1_dashboards_transmissions_path,
            params: { group: 'device_id' },
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
            api_v1_dashboards_transmissions_path,
            params: { group: 'success' },
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
            api_v1_dashboards_transmissions_path,
            params: { group: 'transmitted_at' },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['transmissions']['2019-11-21']).to eq(4) }
          it { expect(json_body['transmissions']['2019-11-24']).to eq(5) }
          it { expect(json_body['group']).to eq('transmitted_at') }
        end
      end

      context 'group by transmitted_at and filter by transmitted_at' do
        before do
          get(
            api_v1_dashboards_transmissions_path,
            params: { group: 'transmitted_at', filter: { transmitted_at: { lteq: '2019-11-22' } } },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['transmissions']['2019-11-21']).to eq(4) }
          it { expect(json_body['group']).to eq('transmitted_at') }
        end
      end

      context 'group by a non-permitted field' do
        before do
          get(
            api_v1_dashboards_transmissions_path,
            params: { group: 'some-other-field' },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['transmissions']['200']).to eq(3) }
          it { expect(json_body['transmissions']['201']).to eq(2) }
          it { expect(json_body['transmissions']['400']).to eq(2) }
          it { expect(json_body['transmissions']['401']).to eq(2) }
          it { expect(json_body['group']).to eq('status') }
        end
      end
    end
  end

  describe 'GET /api/v1/dashboards/messages' do
    let!(:messages) do
      Array.new(3) do
        FactoryBot.create(
          :message,
          account: account,
          origin: device,
          created_at: '2019-11-24'
        )
      end +
        Array.new(2) do
          FactoryBot.create(
            :message,
            account: account,
            origin: device,
            created_at: '2019-11-21'
          )
        end +
        Array.new(2) do
          FactoryBot.create(
            :message,
            account: account,
            origin: device_two,
            created_at: '2019-11-24'
          )
        end +
        Array.new(2) do
          FactoryBot.create(
            :message,
            account: account,
            origin: device_two,
            created_at: '2019-11-21'
          )
        end
    end

    context 'group by origin_id' do
      before do
        get(
          api_v1_dashboards_messages_path,
          params: { filter: { origin_type: 'Device' }, group: 'origin_id' },
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['messages'][device.id.to_s]).to eq(5) }
        it { expect(json_body['messages'][device_two.id.to_s]).to eq(4) }
        it { expect(json_body['group']).to eq('origin_id') }
      end
    end

    context 'group by origin_type' do
      before do
        get(
          api_v1_dashboards_messages_path,
          params: { filter: { device_id: device.id }, group: 'origin_type' },
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['messages']['Device']).to eq(9) }
        it { expect(json_body['messages']['Schedule']).to eq(nil) }
        it { expect(json_body['group']).to eq('origin_type') }
      end
    end

    context 'group by created_at' do
      before do
        get(
          api_v1_dashboards_messages_path,
          params: { filter: { device_id: device.id }, group: 'created_at' },
          headers: authorization_headers
        )
      end

      let(:json_body) { JSON.parse(response.body) }

      context 'stats' do
        it { expect(json_body['messages']['2019-11-21']).to eq(4) }
        it { expect(json_body['messages']['2019-11-24']).to eq(5) }
        it { expect(json_body['group']).to eq('created_at') }
      end
    end

    context 'all devices' do
      context 'group by device_id' do
        before do
          get(
            api_v1_dashboards_messages_path,
            params: { group: 'origin_id' },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['messages'][device.id.to_s]).to eq(5) }
          it { expect(json_body['messages'][device_two.id.to_s]).to eq(4) }
          it { expect(json_body['group']).to eq('origin_id') }
        end
      end

      context 'group by a non-permitted field' do
        before do
          get(
            api_v1_dashboards_messages_path,
            params: { group: 'some-other-field' },
            headers: authorization_headers
          )
        end

        let(:json_body) { JSON.parse(response.body) }

        context 'stats' do
          it { expect(json_body['messages']['0']).to eq(9) }
          it { expect(json_body['group']).to eq('transmission_count') }
        end
      end
    end
  end
end
