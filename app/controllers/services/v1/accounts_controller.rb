# frozen_string_literal: true

module Services
  module V1
    class AccountsController < ServicesController

      # GET /services/v1/accounts
      def index
        render json:
          AccountPresenter.collection_for_microservices(
            Account.active
          )
      end
    end
  end
end

