# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :request do
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

  let(:crm_client) do
    instance_double(
      CRM::Client,
      invalid_session?: false
    )
  end

  before do
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).and_return(crm_session)
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe 'GET /' do
    before do
      get root_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end
end
