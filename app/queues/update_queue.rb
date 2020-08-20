# frozen_string_literal: true

class UpdateQueue
  def initialize(context, exchange)
    @context = context
    @exchange = exchange
  end

  def publish(action, body)
    return if @exchange.blank?

    payload = {
      action: action
    }

    payload[@context] = body

    begin
      bunny_exchange.publish(payload.to_json)

      bunny_connection.close
      @bunny_connection = nil
      @bunny_exchange = nil
    rescue => e
      Rails.logger.warn "The update could not be published to RabbitMQ"
    end
  end

  def bunny_connection
    @bunny_connection ||= begin
      conn = Bunny.new(Rails.configuration.oop[:rabbit][:address])
      conn.start
    end
  end

  def bunny_exchange
    @bunny_exchange ||= begin
      bunny_connection.create_channel
                       .fanout(
                         @exchange,
                         auto_delete: false,
                         durable: true
                       )
    end
  end
end
