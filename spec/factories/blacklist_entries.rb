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

# == Schema Information
#
# Table name: blacklist_entries
#
#  id           :bigint           not null, primary key
#  archived     :boolean          default(FALSE)
#  headers      :string
#  ip_literal   :string
#  ip_range     :string
#  path_literal :string
#  path_regex   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#
