# frozen_string_literal: true

# Methods relating to the user
class User < ApplicationRecord
  has_secure_password

  attr_accessor :password_confirmation

  #
  # Validations
  #
  validates :account_id, presence: true
  validates :email, presence: true, uniqueness:
    { case_sensitive: false, scope: :account_id }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? },
            confirmation: true
  validates :password_confirmation, presence: true, if: -> { !password.nil? }
  validates :time_zone, presence: true
  validates :first_name, format: { with: /\A[a-zA-Z\s-]+\z/,
    message: "only allows letters", allow_blank: true }
  validates :last_name, format: { with: /\A[a-zA-Z\s-]+\z/,
    message: "only allows letters", allow_blank: true }

  #
  # Relationships
  #
  belongs_to :account

  audited except: :password_digest, associated_with: :account

  #
  # Callbacks
  #
  after_create :send_welcome_email

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def send_reset_password_email
    UserMailer.reset_password(self).deliver_now
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

  def generate_password_reset_token!
    update_columns(
      password_reset_token: SecureRandom.hex(40),
      password_reset_requested_at: Time.now
    )
  end

  def valid_password_reset_token?
    password_reset_requested_at <= Time.now + 1.hour
  end

  def clear_password_reset_token!
    update_columns(
      password_reset_token: nil,
      password_reset_requested_at: nil
    )
  end

  def reset_password!(password, password_confirmation)
    self.password = password
    self.password_confirmation = password_confirmation
    self.password_reset_token = nil
    self.password_reset_requested_at = nil
    save
  end
end

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  date_of_birth               :date
#  description                 :text
#  email                       :string
#  first_name                  :string
#  job_title                   :string
#  last_name                   :string
#  password_digest             :string
#  password_reset_requested_at :datetime
#  password_reset_token        :string
#  time_zone                   :string           default("London")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  account_id                  :integer
#
