require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let (:schedule) { FactoryBot.create(:schedule) }

  describe '#tempr_url' do
    it { expect(schedule.tempr_url).to eq("http://test.host:8888/services/v1/schedules/#{schedule.id}/temprs") }
  end
end
