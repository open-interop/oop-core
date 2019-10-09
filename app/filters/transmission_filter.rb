# frozen_string_literal: true

# Filter the transmissions table using the provided fields
class TransmissionFilter < BaseFilter
  filterable_attributes integer: %w[id device_tempr_id status],
                        string: %w[message_uuid transmission_uuid],
                        boolean: %w[success]

  def base_scope
    Transmission
      .includes(:device)
      .where(devices: { id: scope.id })
  end
end
