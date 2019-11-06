FactoryBot.define do
  factory :tempr do
    account { Account.first || create(:account) }
    device_group
    name { 'Some tempr' }
    endpoint_type { 'http' }
    queue_request { false }
    queue_response { false }
    example_transmission do
      {
          key1: 'some-value',
          key2: 'some-value'
      }
    end
    template do
      {
        host: 'example.com',
        port: 80,
        path: '/test',
        request_method: 'POST',
        protocol: 'http',
        headers: {
          'Content-Type': 'application/json'
        },
        body: { language: 'moustache', body: 'asd' }
      }
    end
  end
end
