# frozen_string_literal: true

require 'spec_helper'
require 'zoho'
require 'faraday'

describe Zoho::Org do
  let(:session) do
    Zoho::Session.new(
      {
        'api_domain' => 'https://zoho.domain.test',
        'token' => 'iamatoken'
      }
    )
  end

  let(:client) { Zoho::Client.new(session) }

  describe '.find_by_id' do
    let(:org_response) do
      File.read(File.expand_path('mocks/org.json', __dir__))
    end

    before do
      mock_get_org(200, org_response)
    end

    context 'when successful' do
      it 'returns an instance of Zoho::Org' do
        expect(described_class.find(client))
          .to be_an_instance_of(Zoho::Org)
      end
    end
  end

  Zoho::Org::ATTRIBUTES.each do |attr|
    describe "##{attr.downcase}" do
      let(:opts) do
        JSON.parse(File.read(File.expand_path('mocks/org.json', __dir__)))
      end

      let(:lead) do
        described_class.new(opts)
      end

      it "returns the orgs #{attr.downcase}" do
        expect(lead.send(attr.downcase)).to eq(opts[attr])
      end
    end
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
