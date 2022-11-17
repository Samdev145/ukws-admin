# frozen_string_literal: true

require 'spec_helper'
require 'zoho'
require 'faraday'

describe Zoho::Contact do
  let(:session) do
    Zoho::Session.new(
      {
        'api_domain' => 'https://zoho.domain.test',
        'token' => 'iamatoken'
      }
    )
  end

  let(:client) { Zoho::Client.new(session) }
  let(:contact_data) do
    JSON.parse(
      File.read(File.expand_path('mocks/contact.json', __dir__))
    )['data'][0]
  end
  let(:org_data) do
    JSON.parse(
      File.read(File.expand_path('mocks/org.json', __dir__))
    )['org'][0]
  end

  describe '.search' do
    let(:search_criteria) do
      {
        email: 'testuser@test.com'
      }
    end

    context 'when successful' do
      let(:contacts_response) do
        File.read(File.expand_path('mocks/contacts.json', __dir__))
      end

      before do
        mock_get('/search?email=testuser@test.com', 200, contacts_response)
      end

      it 'returns an array of Zoho::Contact instances' do
        expect(described_class.search(client, search_criteria))
          .to all(be_a(Zoho::Contact))
      end
    end

    context 'when unsuccessful' do
      context 'when a match is not found' do
        let(:contacts_response) { nil }

        before do
          mock_get('/search?email=testuser@test.com', 204, contacts_response)
        end

        it 'returns an empty' do
          expect(described_class.search(client, search_criteria))
            .to eq([])
        end
      end
    end
  end

  describe '.find_by_id' do
    let(:id) { '4353456' }

    let(:contacts_response) do
      File.read(File.expand_path('mocks/contact.json', __dir__))
    end

    let(:org_response) do
      File.read(File.expand_path('mocks/org.json', __dir__))
    end

    before do
      mock_get('/4353456', 200, contacts_response)
      mock_get_org(200, org_response)
    end

    context 'when successful' do
      it 'returns an instance of Zoho::Contact' do
        expect(described_class.find_by_id(client, id))
          .to be_an_instance_of(Zoho::Contact)
      end
    end
  end

  context 'attributes' do
    let(:resource_data) { contact_data }
    it_behaves_like "a CRM resource"
  end

  describe '#link_address' do
    let(:id) { '4353456' }

    let(:contacts_response) do
      File.read(File.expand_path('mocks/contact.json', __dir__))
    end

    let(:org_response) do
      File.read(File.expand_path('mocks/org.json', __dir__))
    end

    before do
      mock_get('/4353456', 200, contacts_response)
      mock_get_org(200, org_response)
    end

    let(:contact) do
      described_class.find_by_id(client, id)
    end

    let(:org_domain_name) do
      org_data['domain_name']
    end

    it 'returns the contacts Zoho CRM link' do
      expect(
        contact.link_address
      ).to eq("https://crm.zoho.eu/crm/#{org_domain_name}/tab/Contacts/#{contact.id}")
    end
  end

  def mock_get(path, status, response)
    stub_request(:get, "https://zoho.domain.test/crm/v3/Contacts#{path}")
      .with(
        headers: {
          'Authorization' => "Bearer #{session.token}"
        }
      ).to_return(
        status: status,
        body: response,
        headers: { 'content-type' => 'application/json' }
      )
  end

  def mock_get_org(status, response)
    stub_request(:get, 'https://zoho.domain.test/crm/v3/org')
      .with(
        headers: {
          'Authorization' => "Bearer #{session.token}"
        }
      ).to_return(
        status: status,
        body: response,
        headers: { 'content-type' => 'application/json' }
      )
  end
end
