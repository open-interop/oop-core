# frozen_string_literal: true

class Package < ApplicationRecord
  #
  # Relationships
  #
  has_many :accounts, dependent: :restrict_with_error


  #
  # Validations
  #
  validates :devices_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :device_groups_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :layers_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :schedules_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :sites_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :temprs_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :users_limit, numericality: { greater_than_or_equal_to: 0 }

end

# == Schema Information
#
# Table name: packages
#
#  id                  :bigint           not null, primary key
#  device_groups_limit :integer          default(0)
#  devices_limit       :integer          default(0)
#  layers_limit        :integer          default(0)
#  name                :string
#  schedules_limit     :integer          default(0)
#  sites_limit         :integer          default(0)
#  temprs_limit        :integer          default(0)
#  users_limit         :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
