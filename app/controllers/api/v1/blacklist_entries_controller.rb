# frozen_string_literal: true

module Api
  module V1
    # BlacklistEntries controller
    # REST actions inherited from API::V1::BaseController
    class BlacklistEntriesController < Api::V1::BaseController
      # GET /api/v1/blacklist_entries
      def index
        @blacklist_entries = BlacklistEntryFilter.records(params, scope: current_account)

        render json:
          BlacklistEntryPresenter.collection(@blacklist_entries, params[:page]), status: :ok
      end

      private

      def record_association
        :blacklist_entries
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'BlacklistEntry'
      end

      def record_params
        params.require(:blacklist_entry).permit(
          :ip_literal,
          :ip_range,
          :path_literal,
          :path_regex,
          :headers,
          :archived
        )
      end
    end
  end
end
