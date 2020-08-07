# frozen_string_literal: true

class BlacklistEntryValidator < ActiveModel::Validator
  def validate(record)
    return if (record.ip_literal.present? && record.ip_literal != "") ||
      (record.ip_range.present? && record.ip_range != "") ||
      (record.path_literal.present? && record.path_literal != "") ||
      (record.path_regex.present? && record.path_regex != "") ||
      (record.headers.present? && record.headers != "")

    record.errors.add(
      :base,
      'A blacklist entry cannot be empty.'
    )
  end
end
