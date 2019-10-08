FactoryBot.define do
  factory :tempr do
    device_group
    name { 'Some tempr' }
    body { { language: "moustache", body: "asd" } }
  end
end
