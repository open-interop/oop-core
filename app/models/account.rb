# frozen_string_literal: true

class Account < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :owner, class_name: 'User', optional: true

  has_many :users, dependent: :restrict_with_error
  has_many :device_groups, dependent: :restrict_with_error
  has_many :devices, dependent: :restrict_with_error
  has_many :sites, dependent: :restrict_with_error
  has_many :temprs, dependent: :restrict_with_error
  has_many :schedules, dependent: :restrict_with_error
  has_many :layers, dependent: :restrict_with_error
  has_many :transmissions, dependent: :restrict_with_error
  has_many :blacklist_entries, dependent: :restrict_with_error

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  #
  # Validations
  #
  validates :hostname, uniqueness: true, presence: true
  validates :interface_scheme, presence: true
  validates :interface_port, presence: true
  validates :interface_path, presence: true

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
end

# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(TRUE)
#  hostname         :string
#  interface_path   :string
#  interface_port   :integer
#  interface_scheme :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :integer
#
