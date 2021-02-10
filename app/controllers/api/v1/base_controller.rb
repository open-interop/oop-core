# frozen_string_literal: true

module Api
  module V1
    # Parent REST API controller
    class BaseController < ApplicationController
      before_action :find_record

      # GET /api/v1/resources/:id
      def show
        render json: @record.to_json(record_json_attributes)
      end

      # POST /api/v1/resources
      def create
        if check_limit?
          @record = current_account.send(record_association).build(record_params)

          if @record.save
            render json: @record.to_json(record_json_attributes), status: :created
          else
            render json: @record.errors, status: :unprocessable_entity
          end
        else
          render json: {'error': 'limit exceeded'}, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/resources/:id
      def update
        if @record.update(record_params)
          render json: @record
        else
          render json: @record.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/resources/:id
      def destroy
        if @record.destroy
          render nothing: true, status: :no_content
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      # GET /api/v1/resources/:id/history
      def audit_logs
        set_audit_logs_filter

        @audit_logs =
          AuditableFilter.records(params, scope: current_account)

        render json:
          AuditablePresenter.collection(@audit_logs, params[:page]), status: :ok
      end

      private

      def record_json_attributes
        {}
      end

      def set_audit_logs_filter
        raise 'Not implemented'
      end

      def check_limit?
        true
      end

      def record_association
        raise 'Not implemented'
      end

      def find_record
        return if params[:id].blank?

        @record = current_account.send(record_association).find(params[:id])
      end
    end
  end
end
