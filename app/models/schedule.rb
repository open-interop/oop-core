# frozen_string_literal: true

class Schedule < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :minute, presence: true
  validates :hour, presence: true
  validates :day_of_week, presence: true
  validates :day_of_month, presence: true
  validates :month_of_year, presence: true
  validates :year, presence: true
  #
  # Relationships
  #
  belongs_to :account

  has_many :schedule_temprs
  has_many :temprs, through: :schedule_temprs
  has_many :transmissions, dependent: :restrict_with_error
  has_many :messages, as: :origin

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  #
  # Callbacks
  #
  after_create :queue_from_create
  after_update :queue_from_update, if: :schedule_changed?
  after_destroy :queue_from_destroy
  after_save do
    Rails.cache.delete([id, 'services/schedules'])
  end

  audited

  def update_queue
    UpdateQueue.new(
      :schedule,
      Rails.configuration.oop[:rabbit][:schedules_exchange]
    )
  end

  def queue_from_create
    update_queue.publish(
      'add',
      SchedulePresenter.record_for_microservices(self)
    )
  end

  def queue_from_update
    @authentication = nil

    update_queue.publish(
      'update',
      SchedulePresenter.record_for_microservices(self)
    )
  end

  def queue_from_destroy
    update_queue.publish(
      'delete',
      SchedulePresenter.record_for_microservices(self)
    )
  end

  def tempr_url
    [].tap do |a|
      a << Rails.configuration.oop[:scheme]
      a << account.hostname

      if Rails.configuration.oop[:port].present? && ![80, 443].include?(Rails.configuration.oop[:port].to_i)
        a << ':'
        a << Rails.configuration.oop[:port]
      end

      a << Rails.configuration.oop[:path] || '/'
      a << "services/v1/schedules/#{id}/temprs"
    end.join
  end

  def schedule_changed?
    saved_change_to_minute? ||
      saved_change_to_hour? ||
      saved_change_to_day_of_week? ||
      saved_change_to_day_of_month? ||
      saved_change_to_month_of_year? ||
      saved_change_to_year?
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
