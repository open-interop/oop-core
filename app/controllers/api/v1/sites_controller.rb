# frozen_string_literal: true

module Api
  module V1
    class SitesController < ApplicationController
      before_action :find_site

      # GET /api/v1/sites
      def index
        @sites = SiteFilter.records(params, scope: current_account)

        render json:
          SitePresenter.collection(@sites, params[:page]), status: :ok
      end

      # GET /api/v1/sites/:id
      def show
        render json: @site
      end

      # POST /api/v1/sites
      def create
        @site = current_account.sites.build(site_params)

        if @site.save
          render json: @site, status: :created
        else
          render json: @site.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/sites/:id
      def update
        if @site.update(site_params)
          render json: @site
        else
          render json: @site.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/sites/:id
      def destroy
        if @site.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      # GET /api/v1/sites/:id/history
      def history
        render json:
          AuditablePresenter.collection(@site.audits, params[:page]), status: :ok
      end

      # GET /api/v1/sites/sidebar
      def sidebar
        @site = current_account.sites.find_by(id: params[:site_id])

        render json:
          SitePresenter.sidebar(current_account, @site), status: :ok
      end

      private

      def find_site
        return if params[:id].blank?

        @site = current_account.sites.find(params[:id])
      end

      def site_params
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
