# frozen_string_literal: true

class DeviceTemprOptionsValidator < ActiveModel::Validator
  def validate(record)
    return unless  missing_options?(record.options) || incorrect_header_format?(record.options)

    record.errors.add(
      :base,
      'You must provide a host, port, path, protocol, and request_method for #options.'
    )
  end

  def missing_options?(record_options)
    [
      record_options[:host],
      record_options[:port],
      record_options[:path],
      record_options[:request_method],
      record_options[:protocol]
    ].any?(&:blank?)
  end

  def incorrect_header_format?(record_options)
    !record_options[:headers]&.is_a?(Hash)
  end
end
