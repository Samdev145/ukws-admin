require 'spec_helper'
require 'zoho/client'
require 'faraday'

describe Zoho::Client do
  
  subject(:crm_client) { described_class.new(session) }

  let(:client) { crm_client.send(:client) }

  let(:session) do
    {
      'api_domain' => 'zoho.domain.test',
      'token' => 'iamatoken'
    }
  end
  
  describe '#contacts' do
    let(:search_criteria) do
      {
        email: 'test@email.com'
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
        email: 'test@email.com'
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
end