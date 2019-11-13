# frozen_string_literal: true

# Methods relating to the device
class Site < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :site, optional: true

  has_many :sites
  has_many :devices

  #
  # Serializers
  #
  serialize :external_uuids, Hash

  audited

  after_save :set_full_name, if: :update_full_name?

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
