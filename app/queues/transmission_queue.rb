class TransmissionQueue
  def self.retrieve_transmissions
    # Start a communication session with RabbitMQ
    conn = Bunny.new
    conn.start

    channel = conn.create_channel

    queue =
      channel.queue(
        Rails.configuration.oop[:rabbit][:response_queue],
        auto_delete: false,
        durable: true
      )

    queue.subscribe(
      block: true,
      manual_ack: true
    ) do |delivery_info, _properties, body|
      transmission_body = JSON.parse(body)

      puts "info:[#{Time.now.iso8601}] oop-core consumed #{transmission_body['uuid']}"

      create_transmission_from_queue(transmission_body)

      channel.ack(delivery_info.delivery_tag)
    end

    conn.close
  end

  def self.create_transmission_from_queue(body)
    return if body.blank?

    data = {
      device_id: body['device']['id'],
      message_uuid: body['uuid'],
      transmission_uuid: body['transmissionId'],
      success: body['tempr']['response']['success'],
      status: body['tempr']['response']['status'],
      transmitted_at: body['tempr']['response']['datetime']
    }

    body['tempr']['queueRequest'] && body['tempr']['rendered'] &&
      data[:request_body] = body['tempr']['rendered']['body']

    body['tempr']['queueResponse'] && body['tempr']['response'] &&
      data[:response_body] = body['tempr']['response']['body']

    Transmission.create!(data)
  end
end
