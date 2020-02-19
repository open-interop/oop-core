# frozen_string_literal: true

# Filter the transmissions table using the provided fields
class TransmissionFilter < BaseFilter
  filterable_attributes integer: %w[id status tempr_id schedule_id],
                        string: %w[message_uuid transmission_uuid],
                        boolean: %w[success],
                        datetime: %w[transmitted_at created_at updated_at]

  sortable_attributes %w[
    id device_id tempr_id schedule_id status message_uuid
    transmission_uuid success transmitted_at
    created_at updated_at
  ]

  def base_scope
    Transmission
      .includes(:device)
      .where(devices: { id: scope })
  end

  def table_name
    Transmission.table_name
  end
end
