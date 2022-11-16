# frozen_string_literal: true

require 'spec_helper'
require 'zoho'
require 'faraday'

describe Zoho::Lead do
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
  let(:lead_data) do
    JSON.parse(File.read(File.expand_path('mocks/lead.json', __dir__)))['data'][0]
  end

  describe '.search' do
    let(:search_criteria) do
      {
        email: 'testuser@test.com'
      }
    end

    context 'when successful' do
      let(:leads_response) do
        File.read(File.expand_path('mocks/leads.json', __dir__))
      end

      before do
        mock_get('/search?email=testuser@test.com', 200, leads_response)
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
          mock_get('/search?email=testuser@test.com', 204, leads_response)
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
      File.read(File.expand_path('mocks/lead.json', __dir__))
    end

    before do
      mock_get('/4353456', 200, leads_response)
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

      let(:lead) do
        described_class.new(lead_data)
      end

      it "returns the leads #{attr.downcase}" do
        expect(lead.send(attr.downcase)).to eq(lead_data[attr])
      end
    end
  end

  describe '#address' do
    let(:lead) do
      described_class.new(opts)
    end

    context 'when all address attributes have been set' do
      let(:opts) { lead_data }

      it 'returns the correctly contructed address' do
        expect(lead.address).to eq('8 Somewhere Drive, City, Country, XY5 5YX')
      end
    end

    context 'when the city has not been set' do
      let(:opts) do
        lead_data.tap do |data|
          data['City'] = nil
        end
      end

      it 'returns the correctly contructed address' do
        expect(lead.address).to eq('8 Somewhere Drive, Country, XY5 5YX')
      end
    end

    context 'when the country has not been set' do
      let(:opts) do
        lead_data.tap do |data|
          data['Country'] = nil
        end
      end

      it 'returns the correctly contructed address' do
        expect(lead.address).to eq('8 Somewhere Drive, City, XY5 5YX')
      end
    end

    context 'when the zip_code has not been set' do
      let(:opts) do
        lead_data.tap do |data|
          data['Zip_Code'] = nil
        end
      end

      it 'returns the correctly contructed address' do
        expect(lead.address).to eq('8 Somewhere Drive, City, Country')
      end
    end
  end

  def mock_get(path, status, response)
    stub_request(:get, "https://zoho.domain.test/crm/v3/Leads#{path}")
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
