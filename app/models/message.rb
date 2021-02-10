# frozen_string_literal: true

class Message < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device, optional: true
  belongs_to :schedule, optional: true
  belongs_to :origin, polymorphic: true

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
  end
end

# == Schema Information
#
# Table name: messages
#
#  id                 :bigint           not null, primary key
#  body               :text
#  ip_address         :string
#  origin_type        :string
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
