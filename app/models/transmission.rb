# frozen_string_literal: true

class Transmission < ApplicationRecord
  STATES = %w[
    successful
    failed
    discarded
  ].freeze

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :message, touch: true
  belongs_to :device, optional: true
  belongs_to :tempr, optional: true
  belongs_to :schedule, optional: true

  #
  # Validations
  #
  validates :state, inclusion: { in: STATES }
  validates :transmission_uuid, uniqueness: true

  def self.create_from_queue(message, body)

    data = {
      message_uuid: message.uuid,
      transmission_uuid: body['transmissionId']
    }

    body['tempr'].present? &&
      data[:tempr_id] = body['tempr']['id']

    data[:account_id] = message.account_id

    body['device'].present? &&
      data[:device_id] = body['device']['id']

    body['tempr'].present? &&
      data[:tempr_id] = body['tempr']['id']

    body['schedule'].present? &&
      data[:schedule_id] = body['schedule']['id']

    if body['tempr']['rendered']
      data[:request_host] = body['tempr']['rendered']['host']
      data[:request_port] = body['tempr']['rendered']['port']
      data[:request_path] = body['tempr']['rendered']['path']
      data[:request_protocol] = body['tempr']['rendered']['protocol']
      data[:request_method] = body['tempr']['rendered']['requestMethod']
      data[:request_headers] =
        if body['tempr']['rendered']['headers'].is_a?(Hash)
          body['tempr']['rendered']['headers'].to_json
        else
          body['tempr']['rendered']['headers']
        end

      if body['tempr']['queueRequest']
        data[:request_body] =
          if body['tempr']['rendered']['body'].is_a?(Hash)
            body['tempr']['rendered']['body'].to_json
          else
            body['tempr']['rendered']['body']
          end
      end
    end

    if body['tempr']['response'].present?
      if body['tempr']['response']['success'] &&
         body['tempr']['response']['discarded']
        data[:discarded] = true
        data[:success] = true
        data[:state] = 'discarded'
      elsif body['tempr']['response']['success']
        data[:success] = true
        data[:state] = 'successful'
      else
        data[:success] = false
        data[:state] = 'failed'
      end

      data[:status] = body['tempr']['response']['status']
      data[:transmitted_at] = body['tempr']['response']['datetime']

      if body['tempr']['queueResponse']
        data[:response_body] =
          if body['tempr']['response']['body'].is_a?(Hash)
            body['tempr']['response']['body'].to_json
          else
            body['tempr']['response']['body']
          end
      end

      body['tempr']['response']['error'] &&
        data[:response_body] = body['tempr']['response']['error']
    end

    if body['customFields'].present?
      if body['customFields']['transmissionFieldA'].present?
        data[:custom_field_a] = body['customFields']['transmissionFieldA']
      end
      if body['customFields']['transmissionFieldB'].present?
        data[:custom_field_b] = body['customFields']['transmissionFieldB']
      end
    end

    message.transmissions.create!(data)
    message.increment!(:transmission_count)
  end

  def retryable?
    [
      request_body,
      request_headers,
      request_host,
      request_method,
      request_path,
      request_port,
      request_protocol
    ].all?
  end

  def retry!
    return if retried?
    return unless retryable?

    begin
      UpdateQueue.publish_to_queue(
        TransmissionPresenter.record_for_microservices(self),
        "#{Rails.configuration.oop[:rabbit][:transmission_retry_queue]}.#{tempr.endpoint_type}",
      )
    rescue => e
      Rails.logger.error "Could not retry transmission #{transmission_uuid}"
      Rails.logger.error e.inspect

      return false
    end

    self.retried_at = Time.zone.now
    self.retried = true

    save
  end
end

# == Schema Information
#
# Table name: transmissions
#
#  id                :bigint           not null, primary key
#  custom_field_a    :string
#  custom_field_b    :string
#  discarded         :boolean          default(FALSE)
#  message_uuid      :string
#  request_body      :text
#  request_headers   :text
#  request_host      :string
#  request_method    :string
#  request_path      :string
#  request_port      :integer
#  request_protocol  :string
#  response_body     :text
#  retried           :boolean          default(FALSE)
#  retried_at        :datetime
#  state             :string
#  status            :integer
#  success           :boolean
#  transmission_uuid :string
#  transmitted_at    :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  device_id         :integer
#  message_id        :integer
#  schedule_id       :integer
#  tempr_id          :integer
#
# Indexes
#
#  index_transmissions_on_account_id  (account_id)
#  index_transmissions_on_created_at  (created_at)
#  index_transmissions_on_device_id   (device_id)
#  index_transmissions_on_message_id  (message_id)
#  index_transmissions_on_retried_at  (retried_at)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (device_id => devices.id)
#  fk_rails_...  (message_id => messages.id)
#
