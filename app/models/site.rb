# frozen_string_literal: true

# Methods relating to the device
class Site < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates_with AccountValidator, fields: %i[site]

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :site, optional: true

  has_many :sites, dependent: :restrict_with_error
  has_many :devices, dependent: :restrict_with_error

  #
  # Serializers
  #
  serialize :external_uuids, Hash

  #
  # Callbacks
  #
  after_save :set_full_name, if: :update_full_name?

  #
  # Scopes
  #
  scope :by_name, -> { order('sites.name asc') }

  audited

  def update_full_name?
    full_name.blank? || saved_change_to_name? || saved_change_to_site_id?
  end

  def set_full_name
    self.full_name = generated_full_name
    save

    update_children
  end

  def generated_full_name
    [].tap do |a|
      a << name

      parent_site = site

      while parent_site.present?
        a << parent_site.name
        parent_site = parent_site.site
      end
    end.reverse.join(' > ')
  end

  def update_children
    sites.each(&:set_full_name)
  end
end

# == Schema Information
#
# Table name: sites
#
#  id             :bigint           not null, primary key
#  address        :string
#  city           :string
#  country        :string
#  description    :text
#  external_uuids :text
#  full_name      :string
#  latitude       :decimal(10, 6)
#  longitude      :decimal(10, 6)
#  name           :string
#  region         :string
#  state          :string
#  time_zone      :string
#  zip_code       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  site_id        :integer
#
