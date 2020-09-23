require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let (:schedule) { FactoryBot.create(:schedule) }

  describe '#tempr_url' do
    it { expect(schedule.tempr_url).to eq("http://test.host:8888/services/v1/schedules/#{schedule.id}/temprs") }
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
