# frozen_string_literal: true

class DeviceAuthenticationValidator < ActiveModel::Validator
  def validate(record)
    return if record.authentication_headers.present? ||
              record.authentication_query.present? ||
              record.authentication_path.present?

    record.errors.add(
      :base,
      'You must provide either header, query, or path authentication.'
    )
  end
end
