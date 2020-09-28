
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

  desc 'Migrate transmisssion_counts'
  task migrate_message_origin: :environment do
    Message.where.not(device_id: nil)
           .group_by(&:device_id)
           .each do |device_id, messages|
      Message.where(id: messages.map(&:id))
             .update_all(
               origin_id: device_id,
               origin_type: 'Device'
             )
    end

    Message.where.not(schedule_id: nil)
           .group_by(&:schedule_id)
           .each do |schedule_id, messages|
      Message.where(id: messages.map(&:id))
             .update_all(
               origin_id: schedule_id,
               origin_type: 'Schedule'
             )
    end
  end
end
