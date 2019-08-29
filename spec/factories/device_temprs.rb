FactoryBot.define do
  factory :device_tempr do
    device
    tempr
    endpoint_type { 'http' }
    queue_response { true }
    template do
      {
        host: Faker::Internet.domain_name,
        path: "/#{Faker::Internet.slug}",
        port: 80,
        requestMethod: 'GET',
        headers: [{ 'Content-Type' => 'application/json' } ],
        protocol: 'https'
      }
    end
  end
end
