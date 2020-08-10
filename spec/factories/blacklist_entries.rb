FactoryBot.define do
  factory :blacklist_entry do
    account { Account.first || FactoryBot.create(:account) }
    ip_literal { Faker::Internet.ip_v4_address }
    ip_range { Faker::Internet.ip_v4_cidr }
    path_literal { '/test/path' }
    path_regex { '/test?pa*th/' }
    headers {}
  end
end
