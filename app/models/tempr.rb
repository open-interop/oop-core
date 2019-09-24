# frozen_string_literal: true

class Tempr < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :body, presence: true

  #
  # Relationships
  #
  belongs_to :device_group

  #
  # Serializations
  #
  serialize :body, Hash
end
