require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let (:schedule) { FactoryBot.create(:schedule) }

  describe '#tempr_url' do
    it { expect(schedule.tempr_url).to eq("http://test.host/services/v1/schedules/#{schedule.id}/temprs") }
  end

  describe '#schedule' do
    it do
      expect(schedule.schedule).to eq(
        minute: schedule.minute,
        hour: schedule.hour,
        dayOfWeek: schedule.day_of_week,
        dayOfMonth: schedule.day_of_month,
        monthOfYear: schedule.month_of_year,
        year: schedule.year
      )
    end
  end
end
