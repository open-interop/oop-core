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
      message_uuid: body['uuid'],
      transmission_uuid: body['transmissionId']
    }

    body['device'].present? &&
      data[:device_id] = body['device']['id']

    body['schedule'].present? &&
      data[:schedule_id] = body['schedule']['id']

    body['tempr']['queueRequest'] && body['tempr']['rendered'] &&
      data[:request_body] = body['tempr']['rendered']['body']

    if body['tempr']['response'].present?
      data[:success] = body['tempr']['response']['success']
      data[:status] = body['tempr']['response']['status']
      data[:transmitted_at] = body['tempr']['response']['datetime']

      body['tempr']['queueResponse'] &&
        data[:response_body] = body['tempr']['response']['body']

      body['tempr']['response']['error'] &&
        data[:response_body] = body['tempr']['response']['error']
    end

    Transmission.create!(data)
  end
end
