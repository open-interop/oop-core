# frozen_string_literal: true

class Message < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device, optional: true
  belongs_to :schedule, optional: true

  has_many :transmissions

  serialize :body, Hash

  def self.create_from_queue(body, import = false)
    return if body.blank?

    account = Account.find_by!(hostname: body['message']['hostname'])

    if (message = account.messages.find_by(uuid: body['uuid'])).blank?
      message = account.messages.build(uuid: body['uuid'])

      body['device'].present? &&
        message.device_id = body['device']['id']

      body['schedule'].present? &&
        message.schedule_id = body['schedule']['id']

      (message.device&.queue_messages || message.schedule&.queue_messages) &&
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
#  id          :bigint           not null, primary key
#  body        :text
#  uuid        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#  device_id   :integer
#  schedule_id :integer
#
# Indexes
#
#  index_messages_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
