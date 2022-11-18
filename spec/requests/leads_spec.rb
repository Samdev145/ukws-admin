# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadsController, type: :request do
  let(:crm_session) do
    {
      CRM::PROVIDER => {
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
        expect(response).to have_http_status(:not_found)
      end

      it 'renders the correct template' do
        expect(response).to render_template('errors/not_found')
      end
    end
  end

  describe 'POST /lead/:id/send_quotation' do
    let(:query_params) do
      {
        start_time: '09:00',
        appointment_duration: 4,
        test: 'yes'
      }
    end

    let!(:product) { create(:product) }
    let!(:employee) { create(:employee) }

    before do
      post send_quotation_lead_path('11111111111111111111112'), params: query_params
    end

    it 'assigns @lead' do
      expect(assigns(:lead)).to eq(lead)
    end

    it 'assigns @installer' do
      expect(assigns(:installer)).to eq(employee)
    end

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'sends the quotation email' do
      mail_double = double
      allow(mail_double).to receive_message_chain(:quotation_email, :deliver_later)

      expect(ContactMailer).to receive(:with) do |opts|
        expect(opts[:lead]).to eq(lead)
        expect(opts[:installer]).to eq(employee)
        expect(opts[:start_time]).to match(query_params[:start_time])
        expect(opts[:product]).to eq(product)
        expect(opts[:test_mode]).to eq(query_params[:test])
      end.and_return(mail_double)

      post send_quotation_lead_path('11111111111111111111112'), params: query_params
    end

    it 'sets the flash message' do
      expect(flash)
        .to receive(:[]=)
        .with(:success, 'The quotation email has been sent')

      post send_quotation_lead_path('11111111111111111111112'), params: query_params
    end

    it 'redirects the correct place' do
      expect(response).to redirect_to(leads_path)
    end
  end

  describe 'GET /lead/:id/quotation_email' do
    let(:query_params) do
      {
        start_time: '09:00',
        appointment_duration: 4,
        test: 'yes'
      }
    end

    let!(:product) { create(:product) }
    let!(:employee) { create(:employee) }

    before do
      get quotation_email_lead_path('11111111111111111111112'), params: query_params
    end

    it 'assigns @lead' do
      expect(assigns(:lead)).to eq(lead)
    end

    it 'assigns @installer' do
      expect(assigns(:installer)).to eq(employee)
    end

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'renders the correct template' do
      expect(response).to render_template('contact_mailer/quotation_email')
    end
  end
end
