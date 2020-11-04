# frozen_string_literal: true

module Api
  module V1
    class AuditsController < ApplicationController
      before_action :find_audit

      # GET /api/v1/audits
      def index
        @audits =
          AuditableFilter.records(
            params,
            scope: current_account
          )

        render json:
          AuditablePresenter.collection(@audits, params[:page]), status: :ok
      end

      # GET /api/v1/audits/1
      def show
        render json: @audit
      end

      private

      def find_audit
        return if params[:id].blank?

        @audit = current_account.audits.find(params[:id])
      end
    end
  end
end
