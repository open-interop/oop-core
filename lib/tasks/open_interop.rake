# frozen_string_literal: true

require 'seed_cli'

namespace :open_interop do
  desc 'Setup initial account'
  task setup_initial_account: :environment do
    SeedCli.account!
  end

  desc 'Generate transmissions for each device'
  task generate_transmissions: :environment do
    if Rails.env.production?
      puts 'Don\'t do this in production...'
      next
    end

    SeedCli.transmissions!
  end
end
