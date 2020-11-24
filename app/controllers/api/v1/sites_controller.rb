# frozen_string_literal: true

module Api
  module V1
    # Sites controller
    # REST actions inherited from API::V1::BaseController
    class SitesController < Api::V1::BaseController
      # GET /api/v1/sites
      def index
        @sites = SiteFilter.records(params, scope: current_account)

        render json:
          SitePresenter.collection(@sites, params[:page]), status: :ok
      end

      # GET /api/v1/sites/sidebar
      def sidebar
        @site = current_account.sites.find_by(id: params[:site_id])

        render json:
          SitePresenter.sidebar(current_account, @site), status: :ok
      end

      private

      def record_association
        :sites
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Site'
      end

      def record_params
        params.require(:site).permit(
          :site_id,
          :name,
          :description,
          :address,
          :city,
          :state,
          :zip_code,
          :country,
          :region,
          :latitude,
          :longitude,
          :time_zone,
          { external_uuids: {} }
        )
      end
    end
  end
end
