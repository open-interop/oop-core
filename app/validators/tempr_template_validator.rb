# frozen_string_literal: true

require 'resolv'

class TemprTemplateValidator < ActiveModel::Validator
  VALID_HOSTNAME_REGEX =
    Regexp.new('(?=^.{1,253}$)(^(((?!-)[a-zA-Z0-9-]{1,63}(?<!-))|((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63})$)').freeze

  def validate(record)
    if missing_options?(record.template)
      record.errors.add(
        :base,
        'You must provide a host, port, path, protocol, and request_method for #template.'
      )
    end

    unless valid_host_format?(record.template)
      record.errors.add(
        :host,
        'is not in the correct format'
      )
    end

    unless valid_header_format?(record.template)
      record.errors.add(
        :headers,
        'is not an object'
      )
    end

    unless valid_body_format?(record.template)
      record.errors.add(
        :body,
        'is not in the correct format'
      )
    end
  end

  def missing_options?(record_options)
    return true if record_options.blank?
    return true if record_options.is_a?(Array)

    [
      record_options[:host],
      record_options[:port],
      record_options[:path],
      record_options[:request_method],
      record_options[:protocol]
    ].any?(&:blank?)
  end

  def valid_host_format?(record_options)
    !record_options[:host].nil? &&
      (
        record_options[:host].match(VALID_HOSTNAME_REGEX).present? ||
          record_options[:host].match(Resolv::IPv4::Regex).present? ||
          record_options[:host].match(Resolv::IPv6::Regex).present?
      )
  end

  def valid_header_format?(record_options)
    return true if record_options[:headers].nil?

    !record_options[:headers].nil? &&
      record_options[:headers].is_a?(Hash)
  end

  def valid_body_format?(record_options)
    return true if record_options[:body].nil?

    !record_options[:body].nil? &&
      record_options[:body].is_a?(Hash)
  end
end
