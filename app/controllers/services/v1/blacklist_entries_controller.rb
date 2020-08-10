# frozen_string_literal: true

module Services
  module V1
    class BlacklistEntriesController < ServicesController

      # GET /services/v1/blacklist_entries
      def index
        render json:
          BlacklistEntryPresenter.collection_for_microservices(
            BlacklistEntry.includes(:account).active
          )
      end
    end
  end
end

