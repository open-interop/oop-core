# frozen_string_literal: true

class Transmission < ApplicationRecord
  paginates_per 10

  #
  # Relationships
  #
  belongs_to :device
  belongs_to :device_tempr, optional: true
end
