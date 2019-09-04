# frozen_string_literal: true

# All controllers inherit from this class
class ApplicationController < ActionController::API
  include AccountableController
  include AuthenticationController

  before_action :login_required

  rescue_from OpenInterop::Errors::AccessDenied, with: :access_denied
  rescue_from OpenInterop::Errors::AccountNotFound, with: :not_found

  private

  def not_found
    render json: { error: 'not_found' }, status: 404
  end

  def access_denied
    render json: { error: 'unauthorized' }, status: 401
  end
end
