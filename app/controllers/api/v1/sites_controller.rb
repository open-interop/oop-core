# frozen_string_literal: true

module Api
  module V1
    class SitesController < ApplicationController
      before_action :find_site

      # GET /sites
      def index
        @sites = current_account.sites.all

        render json: @sites
      end

      # GET /sites/:id
      def show
        render json: @site
      end

      # POST /sites
      def create
        @site = current_account.sites.build(site_params)

        if @site.save
          render json: @site, status: :created, location: @site
        else
          render json: @site.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /sites/:id
      def update
        if @site.update(site_params)
          render json: @site
        else
          render json: @site.errors, status: :unprocessable_entity
        end
      end

      # DELETE /sites/:id
      def destroy
        @site.destroy
      end

      private

      def find_site
        return if params[:id]
        @site = current_account.sites.find(params[:id])
      end

      def site_params
        params.fetch(:site).permit(
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
          :external_uuids
        ).tap do |whitelist|
          whitelist[:external_uuids] = params[:site][:external_uuids]
        end
      end
    end
  end
end
