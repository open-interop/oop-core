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
end