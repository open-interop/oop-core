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
  belongs_to :message
  belongs_to :device, optional: true
  belongs_to :tempr, optional: true
  belongs_to :schedule, optional: true

  #
  # Validations
  #
  validates :state, inclusion: { in: STATES }

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

    data[:retried] = false

    if body['tempr']['queueRequest'] && body['tempr']['rendered']
      data[:request_body] =
        if body['tempr']['rendered']['body'].is_a?(Hash)
          body['tempr']['rendered']['body'].to_json
        else
          body['tempr']['rendered']['body']
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

    message.transmissions.create!(data)
    message.increment!(:transmission_count)
  end

  def retry(transmission) 
    if not transmission.retried
      if message = Message.find_by(id: transmission.message_id)
        UpdateQueue.publish_to_queue(
          MessagePresenter.record_for_microservices(message, false),
          Rails.configuration.oop[:rabbit][:tempr_queue],
        )
        transmission.retried_at = DateTime.now()
        transmission.retried = true
        transmission.save!
      end
    end
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
#  response_body     :text
#  retried           :boolean
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
