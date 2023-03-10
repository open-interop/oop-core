
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

  desc 'Migrate message states'
  task migrate_message_states: :environment do
    failed_transmissions_by_message_id =
      Transmission.select('message_id, count(message_id) as fail_count')
                  .where(state: 'failed')
                  .group(:message_id)

    failed_transmissions_by_message_id.group_by(&:fail_count)
                                      .each do |fails, transmissions|
      Message.where(id: transmissions.map(&:message_id).uniq, transmission_count: fails.to_i)
             .update_all(
               state: 'failed'
             )
    end

    successful_transmissions_by_message_id =
      Transmission.select('message_id, count(message_id) as success_count')
                  .where(state: 'successful')
                  .group(:message_id)

    successful_transmissions_by_message_id.group_by(&:success_count)
                                      .each do |successes, transmissions|
      Message.where(id: transmissions.map(&:message_id).uniq, transmission_count: successes.to_i)
             .update_all(
               state: 'successful'
             )
    end

    Message.where(state: 'unknown').update_all(state: 'action_required')

  end
end
