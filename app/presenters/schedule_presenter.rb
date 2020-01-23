# frozen_string_literal: true

class SchedulePresenter < BasePresenter
  attributes :id, :name, :minute, :hour, :day_of_week,
             :day_of_month, :month_of_year,
             :year, :created_at, :updated_at, :active
end
