# frozen_string_literal: true

FactoryBot.define do
  factory :tempr do
    account { Account.first || create(:account) }
    device_group
    name { 'Some tempr' }
    endpoint_type { 'http' }
    queue_request { false }
    queue_response { false }
    example_transmission do
      '{ "key1" : "some-value", "key2": "some-other-value" }'
    end
    template do
      {
        host: 'example.com',
        port: 80,
        path: '/test/{{message.body.key1}}/{{message.body.key2}}',
        request_method: 'POST',
        protocol: 'http',
        headers: {
          'Content-Type': 'application/json'
        },
        body: {
          language: 'moustache',
          body:
            'asd of this thing {{message.body.key1}} and also {{message.body.key2}}'
        }
      }
    end
  end
end
