# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadsController, type: :request do
  let(:crm_session) do
    {
      CRM::Provider => {
        api_domain: 'https://zoho.domain.test',
        email: 'testadminuser@test.com',
        expires_at: 3600,
        refresh_token: 'xxxx-refresh-token',
        token: 'xxxx-token'
      }
    }
  end

  let(:leads) do
    leads_mock = JSON.parse(
      File.read(
        File.expand_path('../lib/zoho/mocks/leads.json', __dir__)
      )
    )['data']

    leads_mock.map { |lead| Zoho::Lead.new(lead) }
  end

  let(:lead) do
    lead_mock = JSON.parse(
      File.read(
        File.expand_path('../lib/zoho/mocks/leads.json', __dir__)
      )
    )['data'].first

    Zoho::Lead.new(lead_mock)
  end

  let(:crm_client) do
    instance_double(
      Zoho::Client,
      leads: leads,
      find_lead_by_id: lead,
      invalid_session?: false
    )
  end

  before do
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).and_return(crm_session)
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe 'GET /leads' do
    context 'when a search is provided and matched' do
      let(:search_params) do
        {
          search: 'testuser@test.com'
        }
      end

      before do
        get leads_path, params: search_params
      end

      it 'assigns @leads' do
        expect(assigns(:leads)).to eq(leads)
      end
    end

    context 'when a search is provided and not matched' do
      let(:leads) { [] }

      let(:search_params) do
        {
          search: 'nonmatched@test.com'
        }
      end

      it 'does not assign @leads' do
        get leads_path, params: search_params

        expect(assigns(:leads)).to be_empty
      end

      it 'sets the flash message' do
        expect(flash)
          .to receive(:[]=)
          .with('alert', 'No leads could be found by matching the email you provided')

        get leads_path, params: search_params
      end
    end

    context 'when a search is not provided' do
      before do
        get leads_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET /lead/:id' do
    context 'when the lead is found' do
      before do
        create(:employee)
        get lead_path('11111111111111111111112')
      end

      it 'assigns @lead' do
        expect(assigns(:lead)).to eq(lead)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'when the lead is not found' do
      let(:lead) { nil }
      let(:id) { 2 }

      before do
        get lead_path(id)
      end

      it 'assigns @lead' do
        expect(assigns(:lead)).to be_nil
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end
  end
end
