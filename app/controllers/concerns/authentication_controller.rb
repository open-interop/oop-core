# frozen_string_literal: true

module AuthenticationController
  extend ActiveSupport::Concern

  protected

  def logged_in?
    current_user.is_a?(User)
  end

  def current_user
    @current_user ||= (authorize_request || :false)
  end

  def current_user=(new_user)
    @current_user = new_user || :false
  end

  def login_required
    logged_in? || access_denied
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header)
      self.current_user = current_account.users.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      Rails.logger.error e.message.inspect
    end
  end
end
