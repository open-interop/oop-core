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

# == Schema Information
#
# Table name: device_temprs
#
#  id             :bigint           not null, primary key
#  endpoint_type  :string
#  name           :string
#  options        :text
#  queue_response :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  device_id      :integer
#  tempr_id       :integer
#
