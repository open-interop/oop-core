# frozen_string_literal: true

# Methods relating to the schedule tempr,
# this is the join table between schedule and tempr
class ScheduleTempr < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :schedule
  belongs_to :tempr

  #
  # Validations
  #
  validates :tempr_id, uniqueness: { scope: :schedule_id }

  #
  # Callbacks
  #
  after_save do
    Rails.cache.delete([schedule.id, 'services/temprs/schedule'])
  end

  after_destroy do
    Rails.cache.delete([schedule.id, 'services/temprs/schedule'])
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
