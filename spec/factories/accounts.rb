FactoryBot.define do
  factory :account do
    hostname { 'test.host' }
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(TRUE)
#  device_groups_limit :integer          default(0)
#  devices_limit       :integer          default(0)
#  hostname            :string
#  interface_path      :string
#  interface_port      :integer
#  interface_scheme    :string
#  layers_limit        :integer          default(0)
#  name                :string
#  schedules_limit     :integer          default(0)
#  sites_limit         :integer          default(0)
#  temprs_limit        :integer          default(0)
#  users_limit         :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#  package_id          :bigint
#
