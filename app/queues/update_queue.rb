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

    bunny_exchange.publish(payload.to_json)

    bunny_connection.close
    @bunny_connection = nil
    @bunny_exchange = nil
  end

  def bunny_connection
    @bunny_connection ||=
      Bunny.new.start
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
