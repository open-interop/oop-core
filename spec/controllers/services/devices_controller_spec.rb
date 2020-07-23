# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::V1::DevicesController, type: :controller do
  before do
    request.headers['X-Core-Token'] = Rails.configuration.oop[:services_token]
  end

  describe 'GET #auth' do
    context 'returns a success response' do
      before do
        get(:auth, params: {})
      end

      it { expect(response).to be_successful }
    end

    context 'cannot authenticate' do
      before { request.headers['X-Core-Token'] = 'asdasda' }

      before do
        get(:auth, params: {})
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET #temprs' do
    let(:device_tempr) { FactoryBot.create(:device_tempr) }
    let(:device) { device_tempr.device }

    context 'returns a success response' do
      before do
        get(:temprs, params: { id: device.id })
      end

      let(:json_response) { JSON.parse(response.body) }

      it do
        expect(response).to be_successful
      end

      it do
        expect(json_response['ttl']).to eq(Rails.configuration.oop[:tempr_cache_ttl])
      end

      it do
        expect(json_response['data'][0]['id']).to eq(device_tempr.tempr.id)
      end

      it do
        expect(json_response['data'][0]['deviceId']).to eq(device.id)
      end

      it do
        expect(json_response['data'][0]['scheduleId']).to eq(nil)
      end

      it do
        expect(json_response['data'][0]['name']).to eq('Some tempr')
      end

      it do
        expect(json_response['data'][0]['endpointType']).to eq('http')
      end

      it do
        expect(json_response['data'][0]['queueRequest']).to eq(false)
      end

      it do
        expect(json_response['data'][0]['queueResponse']).to eq(false)
      end

      it do
        expect(json_response['data'][0]['template']['host']).to(
          eq(
            "language" => 'text',
            "script" => 'example.com'
          )
        )
      end

      it do
        expect(json_response['data'][0]['template']['port']).to(
          eq(
            "language" => 'text',
            "script" => '80'
          )
        )
      end

      it do
        expect(json_response['data'][0]['template']['path']).to(
          eq(
            "language" => 'text',
            "script" => '/test/{{message.body.key1}}/{{message.body.key2}}'
          )
        )
      end

      it do
        expect(json_response['data'][0]['template']['requestMethod']).to(
          eq(
            "language" => 'text',
            "script" => 'POST'
          )
        )
      end

      it do
        expect(json_response['data'][0]['template']['protocol']).to(
          eq(
            "language" => 'text',
            "script" => 'http'
          )
        )
      end

      it do
        expect(json_response['data'][0]['template']['headers']).to(
          eq(
            "language" => 'js',
            "script" => 'module.exports = { "Content-Type" : "application/json" }'
          )
        )
      end

      it do
        expect(json_response['data'][0]['template']['body']['language']).to(
          eq('mustache')
        )
      end

      it do
        expect(json_response['data'][0]['template']['body']['body']).to(
          eq('asd of this thing {{message.body.key1}} and also {{message.body.key2}}')
        )
      end
    end

    context 'return not found' do
      before do
        get(:temprs, params: { id: 'asd' })
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
