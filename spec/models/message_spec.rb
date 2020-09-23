require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:device) { FactoryBot.create(:device) }
  let(:tempr) { FactoryBot.create(:tempr, queue_request: true, queue_response: true ) }
  let(:device_tempr) { FactoryBot.create(:device_tempr, device: device, tempr: tempr) }

  let(:message_body) do
    {
      uuid: 'de7931c7-1151-46a6-bfe7-a1c779791bb6',
      message: {
        path: '/',
        query: {},
        method: 'GET',
        ip: '::ffff:127.0.0.1',
        body: { 'test-body' => 'something' },
        headers: {
          accept: 'application/json',
          'user-agent': 'node-fetch/1.0 (+https://github.com/bitinn/node-fetch)',
          'accept-encoding': 'gzip,deflate',
          connection: 'close',
          host: 'test.host'
        },
        hostname: 'test.host',
        protocol: 'http'
      },
      device: {
        id: device.id,
        authentication: { hostname: 'test.host', path: '/' }
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
          host: 'test.host',
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
          host: 'test.host',
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

  let(:failed_message_body) do
    {
      uuid: 'bc33b0a4-3cfe-48dc-a964-3b618054e35e',
      message: {
        path: '/gateway/fhir-test/',
        query: {},
        method: 'POST',
        ip: '::ffff:127.0.0.1',
        body: { 'test-body' => 'something' },
        headers: {
          accept: 'application/fhir+json',
          'user-agent': 'Ruby FHIR Client',
          'accept-charset': 'utf-8',
          prefer: 'return=representation',
          'content-type': 'application/fhir+json;charset=utf-8',
          'content-length': '823',
          'accept-encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          host: 'localhost:3000'
        },
        hostname: 'test.host',
        protocol: 'http'
      },
      device: {
        id: device.id,
        authentication: {
          hostname: 'test.host',
          path: '/gateway/fhir-test/'
        }
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
          host: 'test.host',
          path: '/',
          port: 443,
          protocol: 'http',
          requestMethod: 'POST',
          body: {
            language: 'js',
            script: 'module.exports = message'
          }
        },
        createdAt: '2019-11-30T11:43:03.458Z',
        updatedAt: '2019-11-30T11:43:03.458Z',
        temprs: [],
        rendered: {
          headers: {},
          host: 'test.host',
          path: '/',
          port: '443',
          protocol: 'http',
          requestMethod: 'POST',
          body: '{"uuid":"bc33b0a4-3cfe-48dc-a964-3b618054e35e","message":{"path":"/gateway/fhir-test/","query":{},"method":"POST","ip":"::ffff:127.0.0.1","body":{},"headers":{"accept":"application/fhir+json","user-agent":"Ruby FHIR Client","accept-charset":"utf-8","prefer":"return=representation","content-type":"application/fhir+json;charset=utf-8","content-length":"823","accept-encoding":"gzip;q=1.0,deflate;q=0.6,identity;q=0.3","host":"localhost:3000"},"hostname":"localhost","protocol":"http"},"device":{"id":11,"authentication":{"hostname":"localhost","path":"/gateway/fhir-test/"}},"tempr":{"id":6,"deviceId":11,"name":"Passthrough","endpointType":"http","queueRequest":true,"queueResponse":true,"template":{"headers":{},"host":"localhost","path":"/","port":443,"protocol":"http","requestMethod":"POST","body":{"language":"js","script":"module.exports = message"}},"createdAt":"2019-11-30T11:43:03.458Z","updatedAt":"2019-11-30T11:43:03.458Z","temprs":[]},"transmissionId":"39456bf9-7ddb-4625-9f0e-7731ea8b8538"}'
        },
        console: '',
        response: {
          datetime: '2019-11-30T11:48:56.399Z',
          success: false,
          error: 'Unable to do transmission: \'FetchError: request to http://localhost:443/ failed, reason: getaddrinfo ENOTFOUND localhost\'.'
        }
      },
      transmissionId: '39456bf9-7ddb-4625-9f0e-7731ea8b8538',
      retries: 3
    }
  end

  describe '::create_from_queue' do
    context 'response is a string' do
      before do
        described_class.create_from_queue(message_body)
      end

      let(:message) { Message.last }

      it do
        expect(message.uuid).to(
          eq('de7931c7-1151-46a6-bfe7-a1c779791bb6')
        )
      end

      it do
        expect(message.device_id).to eq(device.id)
      end

      it do
        expect(message.body).to(
          eq({})
        )
      end

      xit do
        expect(message.received_at).to(
          eq(Time.zone.parse('2019-11-27T14:54:01.610Z'))
        )
      end
    end

    let(:message_body_with_object_response) do
      {
        uuid: 'de7931c7-1151-46a6-bfe7-a1c779791bb6',
        message: {
          path: '/',
          query: {},
          method: 'GET',
          ip: '::ffff:127.0.0.1',
          body: { 'test-body' => 'something' },
          headers: {
            accept: 'application/json',
            'user-agent': 'node-fetch/1.0 (+https://github.com/bitinn/node-fetch)',
            'accept-encoding': 'gzip,deflate',
            connection: 'close',
            host: 'test.host'
          },
          hostname: 'test.host',
          protocol: 'http'
        },
        device: {
          id: device.id,
          authentication: { hostname: 'test.host', path: '/' }
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
            host: 'test.host',
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
            host: 'test.host',
            path: '/',
            port: '3000',
            protocol: 'http',
            requestMethod: 'GET',
            body: {
              some: 'message'
            }
          },
          response: {
            datetime: '2019-11-27T14:54:01.610Z',
            success: true,
            body: {
              messageUuid: '61932680-9d20-4c66-871b-3c7a70c292ad',
              status: 'success'
            },
            status: 202,
            headers: {}
          }
        },
        transmissionId: 'f12ae1c6-5ae0-4c5e-a02b-5257928c8a89'
      }.with_indifferent_access
    end

    context 'response is an object' do
      before do
        device.update_attribute(:queue_messages, true)
        described_class.create_from_queue(message_body_with_object_response)
      end

      let(:message) { Message.last }

      it do
        expect(message.uuid).to(
          eq('de7931c7-1151-46a6-bfe7-a1c779791bb6')
        )
      end

      it do
        expect(message.device_id).to eq(device.id)
      end

      it do
        expect(message.body).to(
          eq(message_body_with_object_response['message'])
        )
      end

      xit do
        expect(message.transmitted_at).to(
          eq(Time.zone.parse('2019-11-27T14:54:01.610Z'))
        )
      end
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  body        :text
#  uuid        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#  device_id   :integer
#  schedule_id :integer
#
# Indexes
#
#  index_messages_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
