# frozen_string_literal: true

module Api
  module V1
    # Users controller
    # REST actions inherited from API::V1::BaseController
    class UsersController < Api::V1::BaseController
      # GET /api/v1/users
      def index
        @records = UserFilter.records(params, scope: current_account)

        render json:
          UserPresenter.collection(@records, params[:page]), status: :ok
      end

      private

      def record_association
        :users
      end

      def record_json_attributes
        { only: %i[id email time_zone created_at updated_at] }
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'User'
      end

      def record_params
        params.fetch(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :time_zone
        )
      end
    end
  end
end
