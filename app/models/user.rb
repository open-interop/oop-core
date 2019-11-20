# frozen_string_literal: true

# Methods relating to the user
class User < ApplicationRecord
  has_secure_password

  attr_accessor :password_confirmation

  #
  # Validations
  #
  validates :account_id, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
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

  audited except: :password_digest

  #
  # Callbacks
  #
  after_create :send_welcome_email

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def username
    email
  end

  #
  # Authentication
  #
  def self.authenticate_with_password(account, email, password)
    user =
      account.users.where('lower(email) = ?', email.downcase).first

    return if user.blank?

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
