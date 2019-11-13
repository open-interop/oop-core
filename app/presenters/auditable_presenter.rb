# frozen_string_literal: true

class AuditablePresenter < BasePresenter
  attributes :id, :auditable_id, :auditable_type, :associated_id, :associated_type, :user_id, :user_type, :username, :action, :audited_changes, :version, :comment, :remote_address, :request_uuid, :created_at
end
