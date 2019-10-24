# frozen_string_literal: true

# Methods relating to the user
class User < ApplicationRecord
  has_secure_password

  attr_accessor :password_confirmation

  #
  # Validations
  #
  validates :account_id, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? },
            confirmation: true
  validates :password_confirmation, presence: true, if: -> { !password.nil? }
  validates :time_zone, presence: true

  #
  # Relationships
  #
  belongs_to :account

  #
  # Authentication
  #
  def self.authenticate_with_password(account, email, password)
    user =
      account.users.find_by(email: email)

    user.blank? &&
      raise(OpenInterop::Errors::AccessDenied)

    user.authenticate(password)
  end

  def authenticated_token
    @authenticated_token ||=
      {
        token: JsonWebToken.encode(user_id: id),
        exp: (Time.now + 24.hours.to_i).strftime('%m-%d-%Y %H:%M'),
        email: email
      }
  end
end
