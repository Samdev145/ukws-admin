# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactsController, type: :request do
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

  let(:contacts) do
    contacts_mock = JSON.parse(
      File.read(
        File.expand_path('../lib/zoho/mocks/contacts.json', __dir__)
      )
    )['data']

    contacts_mock.map { |contact| Zoho::Contact.new(contact) }
  end

  let(:contact) do
    contact_mock = JSON.parse(
      File.read(
        File.expand_path('../lib/zoho/mocks/contact.json', __dir__)
      )
    )['data'].first

    Zoho::Contact.new(contact_mock)
  end

  let(:crm_client) do
    instance_double(
      Zoho::Client,
      contacts: contacts,
      find_contact_by_id: contact,
      invalid_session?: false
    )
  end

  before do
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).and_return(crm_session)
    allow(CRM::Client).to receive(:new).and_return(crm_client)
  end

  describe 'GET /contacts' do
    context 'when a search is provided and matched' do
      let(:search_params) do
        {
          search: 'testuser@test.com'
        }
      end

      before do
        get contacts_path, params: search_params
      end

      it 'assigns @contacts' do
        expect(assigns(:contacts)).to eq(contacts)
      end
    end

    context 'when a search is provided and not matched' do
      let(:contacts) { [] }

      let(:search_params) do
        {
          search: 'nonmatched@test.com'
        }
      end

      it 'does not assign @contacts' do
        get contacts_path, params: search_params

        expect(assigns(:contacts)).to be_empty
      end

      it 'sets the flash message' do
        expect(flash)
          .to receive(:[]=)
          .with('alert', 'No contacts could be found by matching the email you provided')

        get contacts_path, params: search_params
      end
    end

    context 'when a search is not provided' do
      before do
        get contacts_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET /contact/:id' do
    before do
      get contact_path('11111111111111111111112')
    end

    context 'when the contact is found' do
      it 'assigns @contact' do
        expect(assigns(:contact)).to eq(contact)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'when the contact is not found' do
      let(:contact) { nil }
      let(:id) { 2 }

      before do
        get contact_path(id)
      end

      it 'assigns @contact' do
        expect(assigns(:contact)).to be_nil
      end

      it 'returns http success' do
        expect(response).to have_http_status(:not_found)
      end

      it 'renders the show template' do
        expect(response).to render_template('errors/not_found')
      end
    end
  end
end
