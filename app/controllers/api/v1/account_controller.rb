module Api
  module V1
    # Account controller
    # REST actions inherited from API::V1::BaseController
    class AccountController < Api::V1::BaseController
      # GET /api/v1/account
      def show
        render json: current_account
      end

      def update
        if current_account.update(record_params)
          render json: current_account
        else
          render json: current_account.errors, status: :unprocessable_entity
        end
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Account'
      end

      def record_params
        params.require(:account).permit(
          :name,
          :owner_id,
          :interface_scheme,
          :interface_port,
          :interface_path
        )
      end
    end
  end
end
