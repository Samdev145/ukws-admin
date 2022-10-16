require 'spec_helper'
require 'zoho/client'
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

  let(:crm_client) { Zoho::Client.new(session) }
  let(:client) { crm_client.send(:client) }

  describe '.search' do
    let(:search_criteria) do
      {
        email: 'testuser@test.com'
      }
    end

    context 'when successful' do
      let(:contacts_response) do
        File.read(File.expand_path('../mocks/contacts.json', __FILE__))
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
      File.read(File.expand_path('../mocks/contact.json', __FILE__))
    end

    before do
      mock_get('/4353456', 200, contacts_response)
    end

    context 'when successful' do
      it 'returns an instance of Zoho::Contact' do
        expect(described_class.find_by_id(client, id))
          .to be_an_instance_of(Zoho::Contact)
      end
    end
  end

  Zoho::Contact::ATTRIBUTES.each do |attr|
    describe "##{attr.downcase}" do
      let(:opts) do
        JSON.parse(File.read(File.expand_path('../mocks/contact.json', __FILE__)))
      end

      let(:lead) do
        described_class.new(opts)
      end

      it "should return the contacts #{attr.downcase}" do
        expect(lead.send(attr.downcase)).to eq(opts[attr])
      end
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
end