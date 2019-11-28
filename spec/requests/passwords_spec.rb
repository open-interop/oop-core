# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Passwords", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  before { ActionMailer::Base.deliveries.clear }

  before { Timecop.travel(Time.zone.now) }

  describe 'POST /api/v1/passwords' do
    context 'sends an email' do
      it do
        expect { post api_v1_passwords_path, params: { email: user.email } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with an existing user\'s email address' do
      before do
        post api_v1_passwords_path, params: { email: user.email }
        user.reload
      end

      it { expect(response).to have_http_status(200) }
      it { expect(user.password_reset_requested_at).to_not eq(nil) }
      it { expect(user.password_reset_token).to_not eq(nil) }
    end
  end

  describe 'GET /api/v1/passwords/reset' do
    context 'reset a user\'s password' do
      before do
        user.generate_password_reset_token!
        get api_v1_passwords_reset_path(token: user.password_reset_token)
        user.reload
      end

      it { expect(response).to have_http_status(200) }
    end
  end

  describe 'POST /api/v1/passwords/reset' do
    context 'reset a user\'s password' do
      before do
        user.generate_password_reset_token!

        post(
          api_v1_passwords_reset_path(
            token: user.password_reset_token,
            password: 'newpassword',
            password_confirmation: 'newpassword'
          )
        )

        user.reload
      end

      it { expect(response).to have_http_status(200) }
      it { expect(user.password_reset_requested_at).to eq(nil) }
      it { expect(user.password_reset_token).to eq(nil) }
    end

    context 'fail to reset a user\'s password' do
      before do
        user.generate_password_reset_token!

        post(
          api_v1_passwords_reset_path(
            token: user.password_reset_token,
            password: 'newpassworda',
            password_confirmation: 'newpassword'
          )
        )

        user.reload
      end

      it { expect(response).to have_http_status(422) }
      it { expect(user.password_reset_requested_at).to_not eq(nil) }
      it { expect(user.password_reset_token).to_not eq(nil) }
    end
  end
end
