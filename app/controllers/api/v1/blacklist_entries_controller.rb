# frozen_string_literal: true

module Api
  module V1
    class BlacklistEntriesController < ApplicationController
      before_action :find_blacklist_entry

      # GET /api/v1/blacklist_entries
      def index
        @blacklist_entries = BlacklistEntryFilter.records(params, scope: current_account)

        render json:
          BlacklistEntryPresenter.collection(@blacklist_entries, params[:page]), status: :ok
      end

      # GET /api/v1/blacklist_entries/:id
      def show
        render json: @blacklist_entry
      end

      # POST /api/v1/blacklist_entries
      def create
        @blacklist_entry = current_account.blacklist_entries.build(blacklist_entry_params)

        if @blacklist_entry.save
          render json: @blacklist_entry, status: :created
        else
          render json: @blacklist_entry.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/blacklist_entries/:id
      def update
        if @blacklist_entry.update(blacklist_entry_params)
          render json: @blacklist_entry
        else
          render json: @blacklist_entry.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/blacklist_entries/:id
      def destroy
        if @blacklist_entry.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      # GET /api/v1/blacklist_entries/:id/history
      def history
        render json:
          AuditablePresenter.collection(@blacklist_entry.audits, params[:page]), status: :ok
      end

      private

      def find_blacklist_entry
        return if params[:id].blank?

        @blacklist_entry = current_account.blacklist_entries.find(params[:id])
      end

      def blacklist_entry_params
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
