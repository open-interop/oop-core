# frozen_string_literal: true

module Api
  class V1Controller < ApplicationController
    before_action :find_record

    # GET /api/v1/devices/:id
    def show
      render json: @record
    end

    # POST /api/v1/devices
    def create
      @record = current_account.send(record_association).build(record_params)

      if @record.save
        render json: @record, status: :created
      else
        render json: @record.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/devices/:id
    def update
      if @record.update(record_params)
        render json: @record
      else
        render json: @record.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/devices/:id
    def destroy
      if @record.destroy
        render nothing: true, status: :no_content
      else
        render nothing: true, status: :unprocessable_entity
      end
    end

    # GET /api/v1/devices/:id/history
    def history
      render json:
        AuditablePresenter.collection(@record.audits, params[:page]), status: :ok
    end

    private

    def record_association
      raise 'Not implemented'
    end

    def find_record
      return if params[:id].blank?

      @record = current_account.send(record_association).find(params[:id])
    end
  end
end
