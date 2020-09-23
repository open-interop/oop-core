# frozen_string_literal: true

class CreateLegacyMessagesFromTransmissions < ActiveRecord::Migration[6.0]
  def up
    messages = {}

    Transmission.all
                .group_by(&:message_uuid)
                .each do |message_uuid, transmissions|
      transmission = transmissions.first

      if messages[message_uuid].blank?
        message = Message.new(account_id: transmission.account_id)

        message.uuid = message_uuid

        transmission.device_id.present? &&
          message.device_id = transmission.device_id

        transmission.schedule_id.present? &&
          message.schedule_id = transmission.schedule_id

        message.save!

        messages[message.uuid] = message.id
      end

      Transmission.where(id: transmissions.map(&:id))
                  .update(message_id: messages[message_uuid])
    end
  end

  def down; end
end
