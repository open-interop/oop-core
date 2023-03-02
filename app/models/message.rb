# frozen_string_literal: true
require 'date'

class Message < ApplicationRecord
  STATES = %w[
    successful
    failed
    pending
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

    self
  end

  def set_state!
    transmissions = Transmission.where(:message_uuid => self.uuid)
    failures = transmissions.select do |transmission|
      transmission.state == 'failed'
    end

    if failures.length == transmissions.length
      self.state = 'failed'
    elsif failures.empty?
      self.state = 'successful'
    else
      self.state = 'pending'
    end

    self.save!
  end

  def self.create_from_queue(body, import = false)
    return if body.blank?

    if (message = Message.find_by(uuid: body['uuid'])).blank?
      message = Message.new.create_from_queue(body)

      return if message.origin.blank?

      message.account = message.origin.account

      message.retried = false

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

  def retry(message)
    if message.retried_at.blank?
      UpdateQueue.publish_to_queue(
        MessagePresenter.record_for_microservices(message),
        Rails.configuration.oop[:rabbit][:tempr_queue],
      )
      message.retried_at = DateTime.now()
      message.retried = true
      message.save!
      Transmission.where(message_id: message.id).update_all(retried_at: DateTime.now(), retried: true)
    end
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
#  retried            :boolean
#  retried_at         :datetime
#  state              :string           default("unknown")
#  transmission_count :integer          default(0)
#  uuid               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint
#  device_id          :integer
#  origin_id          :integer
#  schedule_id        :integer
#
# Indexes
#
#  index_messages_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
