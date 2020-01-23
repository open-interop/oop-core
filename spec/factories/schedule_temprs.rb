FactoryBot.define do
  factory :schedule_tempr do
    schedule { Schedule.first || create(:schedule) }
    tempr { Tempr.first || create(:tempr) }
  end
end
