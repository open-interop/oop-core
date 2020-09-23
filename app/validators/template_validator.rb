# frozen_string_literal: true

class TemplateValidator < ActiveModel::Validator
  VALID_LANGUAGES = %i[
    js
    json
    mustache
    text
  ].freeze

  def validate(record)
    options[:fields].each do |field|
      language = record[field][:language]

      !VALID_LANGUAGES.include?(language.to_sym) &&
        record.errors.add(
          field,
          "'#{language}' is not a valid language"
        )
    end
  end
end
