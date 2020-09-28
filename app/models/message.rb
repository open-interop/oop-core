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

  def self.create_from_queue(body, import = false)
    return if body.blank?

    if (message = Message.find_by(uuid: body['uuid'])).blank?
      message = Message.new(uuid: body['uuid'])

      if body['device'].present?
        message.origin_type = 'Device'
        message.origin_id =
          message.device_id = body['device']['id']
      elsif body['schedule'].present?
        message.origin_type = 'Schedule'
        message.origin_id =
          message.schedule_id = body['schedule']['id']
      end

      message.account = message.origin.account

      message.origin&.queue_messages &&
        message.body = body['message']

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
#  origin_type        :string
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
