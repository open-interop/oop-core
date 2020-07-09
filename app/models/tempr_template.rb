# frozen_string_literal: true

class TemprTemplate < ApplicationRecord
  #
  # Validations
  #
  validates :temprs, presence: true

  #
  # Relationships
  #
  has_one :tempr, as: :templateable

  #
  # Serializations
  #
  serialize :temprs, Array

  def render
    {
      temprs: temprs
    }
  end
end
