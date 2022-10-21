# frozen_string_literal: true

require 'rails_helper'
require 'zoho/session'
require 'faraday'
require 'active_support/testing/time_helpers'

describe Zoho::Session do
  include ActiveSupport::Testing::TimeHelpers

  subject(:session) { described_class.new(session_opts) }

  let(:session_opts) do
    {
      'api_domain' => 'https://zoho.domain.test',
      'token' => 'iamatoken',
      'expires_at' => (Time.zone.now + 1.hour).to_i
    }
  end

  describe '#api_domain' do
    it 'returns the api_domain' do
      expect(session.api_domain).to eq(session_opts['api_domain'])
    end
  end

  describe '#token' do
    it 'returns the token' do
      expect(session.token).to eq(session_opts['token'])
    end
  end

  describe '#invalid_session?' do
    context 'when the access token has not expired' do
      it 'returns false' do
        expect(session.invalid_session?).to be(false)
      end
    end

    context 'when the access token has expired' do
      let(:session_opts) do
        {
          'api_domain' => 'https://zoho.domain.test',
          'token' => 'iamatoken',
          'expires_at' => (Time.zone.now - 1.hour).to_i
        }
      end

      context 'when refreshing the token is successful' do
        let(:refresh_token_response) do
          File.read(File.expand_path('mocks/refresh_token.json', __dir__))
        end

        before do
          stub_request(:post, 'https://accounts.zoho.eu/oauth/v2/token?client_id=xxxzohoclientidxxx&client_secret=xxxzohoclientsecretxxx&grant_type=refresh_token&refresh_token')
            .to_return(
              status: 200,
              body: refresh_token_response,
              headers: { 'content-type' => 'application/json' }
            )
        end

        it 'returns false' do
          expect(session.invalid_session?).to be(false)
        end

        it 'sets the new access token' do
          new_access_token = JSON.parse(refresh_token_response)['access_token']
          session.invalid_session?
          expect(session.token).to eq(new_access_token)
        end

        it 'sets the new token expiry time' do
          expiry_in_seconds = JSON.parse(refresh_token_response)['expires_in']

          freeze_time do
            new_expiry_time = Time.zone.now.to_i + expiry_in_seconds
            session.invalid_session?
            expect(session.send(:session)['expires_at']).to eq(new_expiry_time)
          end
        end
      end

      context 'when refreshing the token returns access denied' do
        let(:refresh_token_response) do
          File.read(File.expand_path('mocks/refresh_token_access_denied.json', __dir__))
        end

        before do
          stub_request(:post, 'https://accounts.zoho.eu/oauth/v2/token?client_id=xxxzohoclientidxxx&client_secret=xxxzohoclientsecretxxx&grant_type=refresh_token&refresh_token')
            .to_return(
              status: 200,
              body: refresh_token_response,
              headers: { 'content-type' => 'application/json' }
            )
        end

        it 'returns true' do
          expect(session.invalid_session?).to be(true)
        end
      end
    end
  end
end
