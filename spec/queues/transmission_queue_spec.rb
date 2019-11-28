# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransmissionQueue do
  let(:device) { FactoryBot.create(:device) }
  let(:tempr) { FactoryBot.create(:tempr, queue_request: true, queue_response: true ) }
  let(:device_tempr) { FactoryBot.create(:device_tempr, device: device, tempr: tempr) }

  let(:message) do
    {
      uuid: 'de7931c7-1151-46a6-bfe7-a1c779791bb6',
      message: {
        path: '/',
        query: {},
        method: 'GET',
        ip: '::ffff:127.0.0.1',
        body: {},
        headers: {
          accept: 'application/json',
          'user-agent': 'node-fetch/1.0 (+https://github.com/bitinn/node-fetch)',
          'accept-encoding': 'gzip,deflate',
          connection: 'close',
          host: 'localhost'
        },
        hostname: 'localhost',
        protocol: 'http'
      },
      device: {
        id: device.id,
        authentication: { hostname: 'localhost', path: '/' }
      },
      tempr: {
        id: tempr.id,
        deviceId: device.id,
        name: tempr.name,
        endpointType: tempr.endpoint_type,
        queueRequest: tempr.queue_request,
        queueResponse: tempr.queue_response,
        template: {
          headers: {},
          host: 'localhost',
          path: '/',
          port: 3000,
          protocol: 'http',
          requestMethod: 'GET',
          body: {}
        },
        createdAt: '2019-11-22T16:23:05.422Z',
        updatedAt: '2019-11-26T12:33:10.836Z',
        rendered: {
          headers: {},
          host: 'localhost',
          path: '/',
          port: '3000',
          protocol: 'http',
          requestMethod: 'GET',
          body: '{"some":"message"}'
        },
        response: {
          datetime: '2019-11-27T14:54:01.610Z',
          success: true,
          body: '{"messageUuid":"61932680-9d20-4c66-871b-3c7a70c292ad","status":"success"}',
          status: 202,
          headers: {}
        }
      },
      transmissionId: 'f12ae1c6-5ae0-4c5e-a02b-5257928c8a89'
    }.with_indifferent_access
  end

  describe '::create_transmission_from_queue' do
    before do
      described_class.create_transmission_from_queue(message)
    end

    let(:transmission) { Transmission.last }

    it { expect(transmission.message_uuid).to eq('de7931c7-1151-46a6-bfe7-a1c779791bb6') }
    it { expect(transmission.transmission_uuid).to eq('f12ae1c6-5ae0-4c5e-a02b-5257928c8a89') }
    it { expect(transmission.device_id).to eq(device.id) }
    it { expect(transmission.status).to eq(202) }
    it { expect(transmission.success).to eq(true) }
    it { expect(transmission.response_body).to eq('{"messageUuid":"61932680-9d20-4c66-871b-3c7a70c292ad","status":"success"}') }
    it { expect(transmission.request_body).to eq('{"some":"message"}') }
  end
end
