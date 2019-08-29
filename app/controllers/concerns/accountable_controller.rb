# frozen_string_literal: true

module AccountableController
  extend ActiveSupport::Concern

  protected

  def current_account
    @current_account ||=
      Account.active.find_by(hostname: request.host) ||
      raise(OpenInterop::Errors::AccountNotFound, "Account not found for '#{request.host}'")
  end
end
