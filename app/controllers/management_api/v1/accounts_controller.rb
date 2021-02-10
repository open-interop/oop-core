module ManagementApi
  module V1
    # Packages controller
    # REST actions inherited from ManagementAPI::V1::BaseController
    class AccountsController < ManagementApi::V1::BaseController
      before_action :find_record

      # GET /api/v1/accounts
      def index
        @accounts = AccountFilter.records(params)

        render json:
          AccountPresenter.collection(@accounts, params[:page]), status: :ok
      end

      # SHOW /api/v1/accounts/:id
      def show
        render json: @account.to_json({})
      end

      # POST /api/v1/accounts
      def create
        @account = Account.create(record_params)

        if @account.save
          render json: @account.to_json({}), status: :created
        else
          render json: @account.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/accounts/:id
      def update
        if @account.update(record_params)
          render json: @account
        else
          render json: @account.errors, status: :unprocessable_entity
        end
      end

      private

      def record_association
        :accounts
      end

      def record_params
        params.require(:account).permit(
          :name,
          :owner_id,
          :interface_scheme,
          :interface_port,
          :interface_path,
          :devices_limit,
          :device_groups_limit,
          :layers_limit,
          :schedules_limit,
          :sites_limit,
          :temprs_limit,
          :users_limit,
          :package_id,
          :hostname,
          :active
        )
      end

      def set_audit_logs_filter
        params[:filter] ||= {}
        params[:filter][:auditable_id] = params[:id]
        params[:filter][:auditable_type] = 'Account'
      end

      def find_record
        return if params[:id].blank?

        @account = Account.find(params[:id])
      end
    end
  end
end
