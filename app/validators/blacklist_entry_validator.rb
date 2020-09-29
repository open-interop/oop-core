# frozen_string_literal: true

class BlacklistEntryValidator < ActiveModel::Validator
  def validate(record)
    return if record.ip_literal.present? ||
              record.ip_range.present? ||
              record.path_literal.present? ||
              record.path_regex.present? ||
              record.headers.present?

    record.errors.add(
      :base,
      'A blacklist entry cannot be empty.'
    )
  end
end
