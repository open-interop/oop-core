FactoryBot.define do
  factory :schedule do
    account { Account.first || create(:account) }
    name { 'Schedule test' }
    hour { '12' }
    active { true }
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id             :bigint           not null, primary key
#  active         :boolean          default(TRUE)
#  day_of_month   :string           default("*")
#  day_of_week    :string           default("*")
#  hour           :string           default("*")
#  minute         :string           default("*")
#  month_of_year  :string           default("*")
#  name           :string
#  queue_messages :boolean          default(FALSE)
#  year           :string           default("*")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#
