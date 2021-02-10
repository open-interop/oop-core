# frozen_string_literal: true

class Account < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :package, optional: true

  has_many :users, dependent: :restrict_with_error
  has_many :device_groups, dependent: :restrict_with_error
  has_many :devices, dependent: :restrict_with_error
  has_many :sites, dependent: :restrict_with_error
  has_many :temprs, dependent: :restrict_with_error
  has_many :schedules, dependent: :restrict_with_error
  has_many :layers, dependent: :restrict_with_error
  has_many :transmissions, dependent: :restrict_with_error
  has_many :blacklist_entries, dependent: :restrict_with_error
  has_many :messages, dependent: :restrict_with_error

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  #
  # Callbacks
  #
  after_save :update_limits, if: :saved_change_to_package_id?

  #
  # Validations
  #
  validates :hostname, uniqueness: true, presence: true
  validates :interface_scheme, presence: true
  validates :interface_port, presence: true
  validates :interface_path, presence: true
  validates :devices_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :device_groups_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :layers_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :schedules_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :sites_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :temprs_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :users_limit, numericality: { greater_than_or_equal_to: 0 }

  audited

  before_validation(:default_account_fields, on: :create)

  def default_account_fields
    self.interface_scheme ||= Rails.configuration.oop[:interface][:scheme]
    self.interface_port ||= Rails.configuration.oop[:interface][:port]
    self.interface_path ||= Rails.configuration.oop[:interface][:path]
  end

  def interface_address
    [].tap do |a|
      a << interface_scheme
      a << hostname

      if interface_port.present? && ![80, 443].include?(interface_port.to_i)
        a << ':'
        a << interface_port
      end

      a << interface_path
    end.join
  end

  def update_limits
    if limits_match_default?
      @new_package = Package.find(self.package_id)

      self.device_groups_limit = @new_package.device_groups_limit
      self.devices_limit = @new_package.devices_limit
      self.layers_limit = @new_package.layers_limit
      self.schedules_limit = @new_package.schedules_limit
      self.sites_limit = @new_package.sites_limit
      self.temprs_limit = @new_package.temprs_limit
      self.users_limit = @new_package.users_limit

      self.save!
    end
  end

  def limits_all_zero?
    self.device_groups_limit == 0 &&
    self.devices_limit == 0 &&
    self.layers_limit == 0 &&
    self.schedules_limit == 0 &&
    self.sites_limit == 0 &&
    self.temprs_limit == 0 &&
    self.users_limit == 0
  end

  def limits_match_default?
    if previous_changes[:package_id][0].blank?
      return limits_all_zero?
    end
    begin
      @old_package = Package.find(previous_changes[:package_id][0])
    rescue Exception => e
      p e
    end
    if @old_package.blank?
      return limits_all_zero?
    else
      return @old_package.device_groups_limit == self.device_groups_limit &&
      @old_package.devices_limit == self.devices_limit &&
      @old_package.layers_limit == self.layers_limit &&
      @old_package.schedules_limit == self.schedules_limit &&
      @old_package.sites_limit == self.sites_limit &&
      @old_package.temprs_limit == self.temprs_limit &&
      @old_package.users_limit == self.users_limit
    end
  end

end

# == Schema Information
#
# Table name: accounts
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(TRUE)
#  device_groups_limit :integer          default(0)
#  devices_limit       :integer          default(0)
#  hostname            :string
#  interface_path      :string
#  interface_port      :integer
#  interface_scheme    :string
#  layers_limit        :integer          default(0)
#  name                :string
#  schedules_limit     :integer          default(0)
#  sites_limit         :integer          default(0)
#  temprs_limit        :integer          default(0)
#  users_limit         :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#  package_id          :bigint
#
