# frozen_string_literal: true

# Ensure the site belongs to the same account
class AccountValidator < ActiveModel::Validator
  def validate(record)
    return if options[:fields].blank?

    options[:fields].each do |field|
      association =
        record.send(field)

      next if association.blank?

      next if association.account.id == record.account.id

      record.errors.add(field, 'is not on this account')
    end
  end
end
