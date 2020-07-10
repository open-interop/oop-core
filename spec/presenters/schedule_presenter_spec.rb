require 'rails_helper'

RSpec.describe SchedulePresenter do
  describe '::collection_for_microservices' do
    context 'Schedule' do
      let!(:schedule_tempr) { FactoryBot.create(:schedule_tempr) }
      let(:schedule) { schedule_tempr.schedule }
      let(:tempr) { schedule_tempr.tempr }

      let(:collection) do
        described_class.collection_for_microservices(
          [schedule]
        )
      end

      context '#collection_for_microservices' do
        it do
          expect(collection.first).to(
            eq(
              id: schedule.id,
              name: schedule.name,
              minute: schedule.minute,
              hour: schedule.hour,
              dayOfWeek: schedule.day_of_week,
              dayOfMonth: schedule.day_of_month,
              monthOfYear: schedule.month_of_year,
              year: schedule.year,
              createdAt: schedule.created_at,
              updatedAt: schedule.updated_at,
              tempr_url: schedule.tempr_url
            )
          )
        end
      end
    end
  end
end
