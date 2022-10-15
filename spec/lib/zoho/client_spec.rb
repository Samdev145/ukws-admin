require 'rails_helper'
require 'zoho/client'
require 'faraday'
require 'active_support/testing/time_helpers'

describe Zoho::Client do
  include ActiveSupport::Testing::TimeHelpers
  
  subject(:crm_client) { described_class.new(session) }

  let(:client) { crm_client.send(:client) }

  let(:session) do
    {
      'api_domain' => 'zoho.domain.test',
      'token' => 'iamatoken',
      'expires_at' => (Time.zone.now + 1.hour).to_i
    }
  end
  
  describe '#contacts' do
    let(:search_criteria) do
      {
        email: 'testuser@test.com'
      }
    end

    before do
      allow(Zoho::Contact).to receive(:search)
    end

    it 'calls the correct method on the Contact' do
      crm_client.contacts(search_criteria)

      expect(Zoho::Contact).to have_received(:search).with(client, search_criteria)
    end
  end

  describe '#find_contact_by_id' do
    let(:id) { '4353456' }

    before do
      allow(Zoho::Contact).to receive(:find_by_id)
    end

    it 'calls the correct method on the Contact' do
      crm_client.find_contact_by_id(id)

      expect(Zoho::Contact).to have_received(:find_by_id).with(client, id)
    end
  end

  describe '#leads' do
    let(:search_criteria) do
      {
        email: 'testuser@test.com'
      }
    end

    before do
      allow(Zoho::Lead).to receive(:search)
    end

    it 'calls the correct method on the Lead' do
      crm_client.leads(search_criteria)

      expect(Zoho::Lead).to have_received(:search).with(client, search_criteria)
    end
  end

  describe '#find_lead_by_id' do
    let(:id) { '4353456' }

    before do
      allow(Zoho::Lead).to receive(:find_by_id)
    end

    it 'calls the correct method on the Lead' do
      crm_client.find_lead_by_id(id)

      expect(Zoho::Lead).to have_received(:find_by_id).with(client, id)
    end
  end

  describe '#invalid_session?' do
    
    context 'when the access token has not expired' do

      it 'returns false' do
        expect(crm_client.invalid_session?).to be(false)
      end
    end

    context 'when the access token has expired' do

      let(:session) do
        {
          'api_domain' => 'zoho.domain.test',
          'token' => 'iamatoken',
          'expires_at' => (Time.zone.now - 1.hour).to_i
        }
      end

      context 'when refreshing the token is successful' do
        let(:refresh_token_response) do
          File.read(File.expand_path('../mocks/refresh_token.json', __FILE__))
        end
  
        before do
          stub_request(:post, "https://accounts.zoho.eu/oauth/v2/token?client_id=xxxzohoclientidxxx&client_secret=xxxzohoclientsecretxxx&grant_type=refresh_token&refresh_token").
            to_return(
              status: 200,
              body: refresh_token_response,
              headers: { 'content-type' => 'application/json' }
            )
        end

        it 'returns false' do
          expect(crm_client.invalid_session?).to be(false)
        end

        it 'sets the new access token' do
          new_access_token = JSON.parse(refresh_token_response)['access_token']
          crm_client.invalid_session?
          expect(crm_client.send(:session)['token']).to eq(new_access_token)
        end

        it 'sets the new token expiry time' do
          expiry_in_seconds = JSON.parse(refresh_token_response)['expires_in']

          freeze_time do
            new_expiry_time = Time.zone.now.to_i + expiry_in_seconds
            crm_client.invalid_session?
            expect(crm_client.send(:session)['expires_at']).to eq(new_expiry_time)
          end
        end
      end

      context 'when refreshing the token returns access denied' do
        let(:refresh_token_response) do
          File.read(File.expand_path('../mocks/refresh_token_access_denied.json', __FILE__))
        end
  
        before do
          stub_request(:post, "https://accounts.zoho.eu/oauth/v2/token?client_id=xxxzohoclientidxxx&client_secret=xxxzohoclientsecretxxx&grant_type=refresh_token&refresh_token").
            to_return(
              status: 200,
              body: refresh_token_response,
              headers: { 'content-type' => 'application/json' }
            )
        end

        it 'returns true' do
          expect(crm_client.invalid_session?).to be(true)
        end
      end
    end
  end
end
