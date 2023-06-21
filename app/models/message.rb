# frozen_string_literal: true

class Message < ApplicationRecord
  STATES = %w[
    successful
    failed
    action_required
    unknown
  ].freeze

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device, optional: true
  belongs_to :schedule, optional: true
  belongs_to :origin, polymorphic: true

  #
  # Validations
  #
  validates :state, inclusion: { in: STATES }

  has_many :transmissions

  serialize :body, Hash

  audited associated_with: :account

  after_touch :set_state!

  def create_from_queue(body)
    self.uuid = body['uuid']

    if body['device'].present?
      self.origin_type = 'Device'
      self.origin_id =
        self.device_id = body['device']['id']
    elsif body['schedule'].present?
      self.origin_type = 'Schedule'
      self.origin_id =
        self.schedule_id = body['schedule']['id']
    end

    if body['customFields'].present?
      if body['customFields']['messageFieldA'].present?
        self.custom_field_a = body['customFields']['messageFieldA']
      end
      if body['customFields']['messageFieldB'].present?
        self.custom_field_b = body['customFields']['messageFieldB']
      end
    end

    self
  end

  def set_state!
    failures = transmissions.where(retried: false, state: 'failed')

    self.state =
      if failures.size.zero?
        'successful'
      elsif failures.count == transmissions.where(retried: false).count
        'failed'
      else
        'action_required'
      end

    save
  end

  def self.create_from_queue(body, import = false)
    return if body.blank?

    if (message = Message.find_by(uuid: body['uuid'])).blank?
      message = Message.new.create_from_queue(body)

      return if message.origin.blank?

      message.account = message.origin.account

      message.origin.queue_messages &&
        message.body = body['message']

      body['message'] &&
        message.ip_address = body['message']['ip']

      message.save!
    end

    return message if import

    Transmission.create_from_queue(message, body)

    message.set_state!
  end

  def retry!
    return if retried?

    begin
      UpdateQueue.publish_to_queue(
        MessagePresenter.record_for_microservices(self),
        Rails.configuration.oop[:rabbit][:message_retry_queue],
      )
    rescue => e
      Rails.logger.error "Could not retry message #{uuid}"
      Rails.logger.error e.inspect

      return false
    end

    self.retried_at = Time.zone.now
    self.retried = true

    return unless save

    transmissions.update_all(
                    retried_at: Time.zone.now,
                    retried: true
                  )

    set_state!

    true
  end
end

# == Schema Information
#
# Table name: messages
#
#  id                 :bigint           not null, primary key
#  body               :text
#  custom_field_a     :string
#  custom_field_b     :string
#  ip_address         :string
#  origin_type        :string
#  retried            :boolean          default(FALSE)
#  retried_at         :datetime
#  state              :string           default("unknown")
#  transmission_count :integer          default(0)
#  uuid               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  device_id          :integer
#  origin_id          :integer
#  schedule_id        :integer
#
# Indexes
#
#  index_messages_on_account_id                 (account_id)
#  index_messages_on_created_at                 (created_at)
#  index_messages_on_device_id                  (device_id)
#  index_messages_on_origin_id_and_origin_type  (origin_id,origin_type)
#  index_messages_on_retried_at                 (retried_at)
#  index_messages_on_schedule_id                (schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (device_id => devices.id)
#  fk_rails_...  (schedule_id => schedules.id)
#
