# frozen_string_literal: true

require 'io/console'

class SeedCli
  def self.bold_text(text)
    "\e[1m#{text}\e[22m"
  end

  def self.question(text)
    print bold_text("#{text}: ")
    answer = $stdin.gets.chomp

    answer.blank? ? nil : answer
  end

  def self.account!
    puts

    name = question('What\'s the name of your account? [default: Test Account]')
    hostname = question('What\'s the domain of your account? [default: localhost]')

    Account.transaction do
      account = Account.new(
        name: name ||= 'Test Account',
        hostname: hostname ||= 'localhost'
      )

      if account.save
        puts "#{name} account appears valid."
      else
        puts
        puts bold_text('Account is not valid:')

        account.errors.full_messages.each { |error| puts "- #{error}" }
        puts

        return
      end

      email = question('User email address')
      password = $stdin.getpass(bold_text('Password: '))
      password_confirmation = $stdin.getpass(bold_text('Confirm password: '))

      user = account.users.build(
        email: email,
        time_zone: 'UTC'
      )

      user.password = password
      user.password_confirmation = password_confirmation

      unless user.save
        puts
        puts bold_text('User is not valid:')

        user.errors.full_messages.each { |error| puts "- #{error}" }
        puts

        raise(ActiveRecord::Rollback, 'Invalid details provided.')
      end

      account.owner = user

      account.save
    end
  end

  def self.transmissions!
    account_id = question('What is the ID of the account?')
    account = Account.find(account_id)

    transmissions = question('How many transmissions do you want to create?')

    if (number_of_transmissions = transmissions.to_f) <= 0
      number_of_transmissions = 100.0
    end

    minimum_number_of_transmissions = number_of_transmissions / 2.0

    days = question('Over how many days do you want to create transmissions?')

    if (number_of_days = days.to_i) <= 0
      number_of_days = 30
    end

    puts
    puts "You are going to generate transmissions for #{account.name} (#{account.hostname})."
    puts "You have selected between #{minimum_number_of_transmissions} and #{number_of_transmissions} per device."
    puts "You are generating transmissions for the last #{number_of_days} day(s)."
    puts

    puts 'Are you sure?'
    puts

    confirmation = question('Y/N [default: N]').downcase

    return unless %w[y yes].include?(confirmation)

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
