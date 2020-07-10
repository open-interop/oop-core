# frozen_string_literal: true

class SchedulePresenter < BasePresenter
  attributes :id, :name, :minute, :hour, :day_of_week,
             :day_of_month, :month_of_year,
             :year, :created_at, :updated_at, :active

  def self.record_for_microservices(schedule)
    {
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
    }
  end

  def self.collection_for_microservices(schedules)
    schedules.map do |schedule|
      record_for_microservices(schedule)
    end
  end
end
