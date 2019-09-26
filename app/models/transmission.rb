# frozen_string_literal: true

class Transmission < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :device
  belongs_to :device_tempr, optional: true
end
