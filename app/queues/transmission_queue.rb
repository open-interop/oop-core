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

    queue.subscribe(
      block: true,
      manual_ack: true,
      consumer_tag: 'oop_core_transmissions'
    ) do |delivery_info, _properties, body|
      transmission_body = JSON.parse(body)

      puts "info:[#{Time.now.iso8601}] oop-core consumed #{transmission_body['uuid']}"

      Message.create_from_queue(transmission_body)

      channel.ack(delivery_info.delivery_tag)
    end

    conn.close
  end
end
