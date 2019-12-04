# frozen_string_literal: true

namespace :open_interop do
  desc 'Generate transmissions for each device'
  task generate_transmissions: :environment do
    if Rails.env.production?
      puts 'Don\'t do this in production...'
      next
    end

    account = Account.find(ENV['account_id'])

    if (number_of_transmissions = ENV['transmissions'].to_f) <= 0
      number_of_transmissions = 100.0
    end

    minimum_number_of_transmissions = number_of_transmissions / 2.0

    if (number_of_days = ENV['days'].to_i) <= 0
      number_of_days = 30
    end

    puts
    puts "You are going to generate transmissions for #{account.name} (#{account.hostname})."
    puts "You have selected between #{minimum_number_of_transmissions} and #{number_of_transmissions} per device."
    puts "You are generating transmissions for the last #{number_of_days} day(s)."
    puts

    puts 'Are you sure?'
    puts

    print 'Y/N (Default: N) : '
    confirmation = STDIN.gets.strip.downcase

    next unless ['y', 'yes'].include?(confirmation)

    puts

    to_date = Date.today
    from_date = to_date - number_of_days.days

    (from_date...to_date).each do |transmission_date|
      puts "Generating transmissions on #{transmission_date}"
      account.devices.each do |device|
        puts "For #{device.name}"

        rand(minimum_number_of_transmissions...number_of_transmissions).to_i.times do
          successful_transmission = [true, false].sample

          status_of_transmission =
            if successful_transmission
              [200, 201, 202].sample
            else
              [400, 401, 403].sample
            end

          device.transmissions.create!(
            message_uuid: SecureRandom.uuid,
            transmission_uuid: SecureRandom.uuid,
            success: successful_transmission,
            status: status_of_transmission,
            transmitted_at: transmission_date
          )
        end
      end
    end
  end
end
