FactoryBot.define do
  factory :device_tempr do
    name { Faker::Books::Dune.character }
    device { Device.first || create(:device) }
    tempr { Tempr.first || create(:tempr) }
    endpoint_type { 'http' }
    queue_response { true }
    options do
      {
        host: Faker::Internet.domain_name,
        path: "/#{Faker::Internet.slug}",
        port: 80,
        request_method: 'GET',
        headers: { 'Content-Type' => 'application/json' },
        protocol: 'https'
      }
    end
  end
end
