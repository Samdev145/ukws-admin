require 'spec_helper'
require 'zoho/client'
require 'faraday'

describe Zoho::Lead do

  let(:session) do
    {
      'api_domain' => 'https://zoho.domain.test',
      'token' => 'iamatoken'
    }
  end

  let(:crm_client) { Zoho::Client.new(session) }
  let(:client) { crm_client.send(:client) }

  describe '.search' do 
    let(:search_criteria) do
      {
        email: 'test@email.com'
      }
    end

    context 'when successful' do
      let(:leads_response) do
        File.read(File.expand_path('../mocks/leads.json', __FILE__))
      end

      before do
        stub_request(:get, "https://zoho.domain.test/crm/v3/Leads/search?email=test@email.com")
          .with(
            headers: {
              'Authorization' => "Bearer #{session['token']}"
            }
          ).to_return(
            status: 200,
            body: leads_response,
            headers: { 'content-type' => 'application/json' }
          )
      end

      it 'returns an array of Zoho::Lead instances' do
        expect(described_class.search(client, search_criteria))
          .to all(be_a(Zoho::Lead))
      end
    end

    context 'when unsuccessful' do
      context 'when a match is not found' do
        let(:leads_response) { nil }

        before do
          stub_request(:get, "https://zoho.domain.test/crm/v3/Leads/search?email=test@email.com")
            .with(
              headers: {
                'Authorization' => "Bearer #{session['token']}"
              }
            ).to_return(
              status: 204,
              body: leads_response,
              headers: { 'content-type' => 'application/json' }
            )
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

    let(:leads_response) do
      File.read(File.expand_path('../mocks/lead.json', __FILE__))
    end

    before do
      stub_request(:get, "https://zoho.domain.test/crm/v3/Leads/4353456")
        .with(
          headers: {
            'Authorization' => "Bearer #{session['token']}"
          }
        ).to_return(
          status: 200,
          body: leads_response,
          headers: { 'content-type' => 'application/json' }
        )
    end

    context 'when successful' do
      it 'returns an instance of Zoho::Lead' do
        expect(described_class.find_by_id(client, id))
          .to be_an_instance_of(Zoho::Lead)
      end
    end
  end

  Zoho::Lead::ATTRIBUTES.each do |attr|
    describe "##{attr.downcase}" do
      let(:opts) do
        JSON.parse(File.read(File.expand_path('../mocks/lead.json', __FILE__)))
      end

      let(:lead) do
        described_class.new(opts)
      end

      it "should return the leads #{attr.downcase}" do
        expect(lead.send(attr.downcase)).to eq(opts[attr])
      end
    end
  end
end
