# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  describe 'GET /:adapter/login' do
    context 'when using the crm adapter' do
      before do
        get '/crm/login'
      end

      it 'assigns @adapter' do
        expect(assigns(:adapter)).to eq(CRM)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the new template' do
        expect(response).to render_template('new')
      end
    end

    context 'when using the calendar adapter' do
      before do
        get '/calendar/login'
      end

      it 'assigns @adapter' do
        expect(assigns(:adapter)).to eq(CALENDAR)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the new template' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET /logout' do
    before do
      get logout_path
    end

    it 'sets the crm session to nil' do
      expect(session[CRM::PROVIDER]).to be_nil
    end

    it 'sets the calendar session to nil' do
      expect(session[CALENDAR::PROVIDER]).to be_nil
    end

    it 'redirects to the correct place' do
      expect(response).to redirect_to(root_path)
    end
  end
end
