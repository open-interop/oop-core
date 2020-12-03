
namespace :open_interop do
  desc 'Migrate legacy transmisions'
  task migrate_legacy_transmissions: :environment do
    messages = {}

    Transmission.all
                .group_by(&:message_uuid)
                .each do |message_uuid, transmissions|
      transmission = transmissions.first

      if messages[message_uuid].blank?
        message = Message.new(account_id: transmission.account_id)

        message.uuid = message_uuid

        if transmission.device_id.present?
          message.origin_id = transmission.device_id
          message.origin_type = 'Device'
        elsif transmission.schedule_id.present?
          message.origin_id = transmission.schedule_id
          message.origin_type = 'Schedule'
        end

        message.save!

        messages[message.uuid] = message.id
      end

      Transmission.where(id: transmissions.map(&:id))
                  .update(message_id: messages[message_uuid])
    end
  end

  desc 'Migrate transmisssion_counts'
  task migrate_transmission_counts: :environment do
    transmissions_by_message_id =
      Transmission.select('message_id, count(message_id) as transmission_count')
                  .group(:message_id)

    transmissions_by_message_id.group_by(&:transmission_count)
                               .each do |count, transmissions|
      Message.where(id: transmissions.map(&:message_id).uniq)
             .update_all(
               transmission_count: count.to_i
             )
    end
  end
end
