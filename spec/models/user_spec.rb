require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when created' do
    context 'send an email' do
      it do
        expect { FactoryBot.create(:user) }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end

  describe '#valid_password_reset_token?' do
    let(:user) { FactoryBot.create(:user) }

    before { user.generate_password_reset_token! }

    context 'an expired token' do
      before { Timecop.travel(Time.zone.now - 2.days) }

      it { expect(user.valid_password_reset_token?).to eq(false) }
    end

    context 'a valid token' do
      before { Timecop.travel(Time.zone.now + 1.day) }

      it { expect(user.valid_password_reset_token?).to eq(true) }
    end
  end

  describe '#username' do
    let(:user) { FactoryBot.create(:user) }

    it { expect(user.username).to eq(user.email) }
  end

  describe '#reset_password' do
    let(:user) { FactoryBot.create(:user) }

    before do
      user.reset_password!(
        'newpassword',
        'newpassword'
      )
    end

    it { expect(user).to be_valid }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  email                       :string
#  password_digest             :string
#  password_reset_requested_at :datetime
#  password_reset_token        :string
#  time_zone                   :string           default("London")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  account_id                  :integer
#
