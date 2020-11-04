# frozen_string_literal: true

class BlacklistEntry < ApplicationRecord
  #
  # Validations
  #
  validates_with BlacklistEntryValidator

  #
  # Relationships
  #
  belongs_to :account

  # Scopes
  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
  #
  # Callbacks
  #
  after_create :queue_from_create
  after_update :queue_from_update, if: :blacklist_entry_changed?
  after_destroy :queue_from_destroy
  after_save do
    Rails.cache.delete([id, 'services/blacklist_entries'])
  end

  audited associated_with: :account

  def update_queue
    UpdateQueue.new(
      :blacklist_entry,
      Rails.configuration.oop[:rabbit][:blacklist_entries_exchange]
    )
  end

  def queue_from_create
    update_queue.publish(
      'add',
      BlacklistEntryPresenter.record_for_microservices(self)
    )
  end

  def queue_from_update
    @authentication = nil

    update_queue.publish(
      'update',
      BlacklistEntryPresenter.record_for_microservices(self)
    )
  end

  def queue_from_destroy
    update_queue.publish(
      'delete',
      BlacklistEntryPresenter.record_for_microservices(self)
    )
  end

  def blacklist_entry_changed?
    saved_change_to_ip_literal? ||
      saved_change_to_ip_range? ||
      saved_change_to_path_literal? ||
      saved_change_to_path_regex?
  end
end

# == Schema Information
#
# Table name: blacklist_entries
#
#  id           :bigint           not null, primary key
#  archived     :boolean          default(FALSE)
#  headers      :string
#  ip_literal   :string
#  ip_range     :string
#  path_literal :string
#  path_regex   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#
