# frozen_string_literal: true

class TransmissionQueue
  def self.retrieve_transmissions
    # Start a communication session with RabbitMQ
    conn = Bunny.new(Rails.configuration.oop[:rabbit][:address])
    conn.start

    channel = conn.create_channel
    channel.prefetch(Rails.configuration.oop[:rabbit][:prefetch_limit] || 0)

    queue =
      channel.queue(
        Rails.configuration.oop[:rabbit][:response_queue],
        auto_delete: false,
        durable: true
      )

    puts "info:[#{Time.now.iso8601}] oop-core queue connected"

    queue.subscribe(
      manual_ack: true,
      consumer_tag: 'oop_core_transmissions'
    ) do |delivery_info, _properties, body|
      transmission_body = JSON.parse(body)

      ActiveRecord::Base.transaction do
        begin
          Timeout::timeout(60) do
            Message.create_from_queue(transmission_body)
          end

          channel.ack(delivery_info.delivery_tag, false)
          puts "info:[#{Time.now.iso8601}] oop-core consumed #{transmission_body['uuid']}"
        rescue ActiveRecord::RecordInvalid => e
          puts e.inspect
          channel.ack(delivery_info.delivery_tag, false)
          puts "info:[#{Time.now.iso8601}] oop-core discarded #{transmission_body['uuid']}"
        rescue Timeout::Error => e
          puts e.inspect
          channel.nack(delivery_info.delivery_tag, false, true)
          puts "error:[#{Time.now.iso8601}] oop-core timeout #{transmission_body['uuid']}"
        rescue => e
          puts e.inspect
          channel.nack(delivery_info.delivery_tag, false, true)
          puts "error:[#{Time.now.iso8601}] oop-core unknown error #{transmission_body['uuid']}"
        end
      end
    end

    loop { sleep 1 }

  rescue Bunny::ChannelAlreadyClosed => e
    puts e.inspect
    puts "error:[#{Time.now.iso8601}] oop-core unknown error channel closed"
    raise(e)
  end
end
