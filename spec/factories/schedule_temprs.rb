FactoryBot.define do
  factory :schedule_tempr do
    schedule { Schedule.first || create(:schedule) }
    tempr { Tempr.first || create(:tempr) }
  end
end

# == Schema Information
#
# Table name: schedule_temprs
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  schedule_id :integer
#  tempr_id    :integer
#
