# frozen_string_literal: true

class TemprTemplateValidator < ActiveModel::Validator
  def validate(record)
    if missing_options?(record.template)
      record.errors.add(
        :base,
        'You must provide a host, port, path, protocol, and request_method for #template.'
      )
    end

    if incorrect_header_format?(record.template)
      record.errors.add(
        :headers,
        'You must provide headers as an object.'
      )
    end

    if incorrect_body_format?(record.template)
      record.errors.add(
        :body,
        'Incorrect body format.'
      )
    end
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
    !record_options[:headers].nil? && !record_options[:headers].is_a?(Hash)
  end

  def incorrect_body_format?(record_options)
    !record_options[:body].nil? && !record_options[:body].is_a?(Hash)
  end
end
