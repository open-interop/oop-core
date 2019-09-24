class TransmissionQueue
  def self.retrieve_transmissions
    # Start a communication session with RabbitMQ
    conn = Bunny.new
    conn.start

    channel = conn.create_channel

    queue =
      channel.queue(
        ENV['OOP_CORE_RESPONSE_Q'],
        auto_delete: false,
        durable: true
      )

    queue.subscribe(
      block: true,
      manual_ack: true
    ) do |delivery_info, _properties, body|
      puts "#{Time.now.to_s(:db)}: Received: #{body}"

      transmission_body = JSON.parse(body)

      Transmission.create(
        device_id: transmission_body['deviceId'],
        device_tempr_id: transmission_body['deviceTemprId'],
        message_uuid: transmission_body['messageId'],
        transmission_uuid: transmission_body['transmissionId'],
        success: transmission_body['success'],
        status: transmission_body['status'],
        transmitted_at: transmission_body['datetime'],
        body: transmission_body['body']
      )

      channel.ack(delivery_info.delivery_tag)
    end

    conn.close
  end
end
