FactoryBot.define do
  factory :account do
    hostname { 'test.host' }
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(TRUE)
#  hostname         :string
#  interface_path   :string
#  interface_port   :integer
#  interface_scheme :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :integer
#
