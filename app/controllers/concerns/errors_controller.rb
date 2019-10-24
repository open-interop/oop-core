# frozen_string_literal: true

# Render JSON on errors, not an html page
module ErrorsController
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :internal_server_error
    rescue_from OpenInterop::Errors::AccessDenied, with: :access_denied
    rescue_from OpenInterop::Errors::AccountNotFound, with: :not_found
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  def not_found(errors = '')
    render json: {
      message: 'not_found',
      errors: Array.wrap(errors)
    }, status: 404
  end

  def access_denied(errors = '')
    render json: {
      message: 'unauthorized',
      errors: Array.wrap(errors)
    }, status: 401
  end

  def internal_server_error(errors = '')
    render json: {
      message: 'internal_server_error',
      errors: Array.wrap(errors),
      stacktrace: Array.wrap(errors.backtrace)
    }, status: 500
  end
end
