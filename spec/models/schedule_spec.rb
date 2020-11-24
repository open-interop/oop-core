require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let (:schedule) { FactoryBot.create(:schedule) }

  context 'with children' do
    let!(:messages) do
      Array.new(2) do
        FactoryBot.create(:message, origin: schedule)
      end
    end

    it do
      expect do
        schedule.destroy
      end.to change(Schedule, :count).by(0)
    end

    it { expect(schedule.destroy).to eq(false) }

    it do
      expect do
        schedule.destroy
      end.to change(Message, :count).by(0)
    end

    context 'once children are removed' do
      before { messages.each(&:destroy) }

      it do
        expect do
          schedule.destroy
        end.to change(Schedule, :count).by(-1)
      end

      it { expect(schedule.destroy).to_not eq(false) }
    end

    context 'force deletion' do
      before do
        schedule.force_delete = true
      end

      it do
        expect do
          schedule.destroy
        end.to change(Schedule, :count).by(-1)
      end

      it { expect(schedule.destroy).to_not eq(false) }
    end
  end

  describe '#tempr_url' do
    it do
      expect(schedule.tempr_url).to(
        eq("http://test.host:8888/services/v1/schedules/#{schedule.id}/temprs")
      )
    end
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
