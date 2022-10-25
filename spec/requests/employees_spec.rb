# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :request do
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

  describe 'GET /employees' do
    before do
      get employees_path
    end

    it 'assigns @employee' do
      employees = Employee.all
      expect(assigns(:employees)).to eq(employees)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET /employees/new' do
    before do
      get new_employee_path
    end

    it 'assigns @employee' do
      expect(assigns(:employee)).to be_a(Employee)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end
  end

  describe 'POST /employees' do
    let(:valid_employee_params) do
      {
        employee: (attributes_for :employee)
      }
    end

    context 'when creating the employee is successful' do
      it 'increments the Employee count by 1' do
        expect do
          post employees_path, params: valid_employee_params
        end.to change(Employee, :count).by(1)
      end

      it 'redirect the correct place' do
        post employees_path, params: valid_employee_params

        expect(response).to redirect_to(employees_path)
      end
    end

    context 'when creating the employee is unsuccessful' do
      let(:invalid_employee_params) do
        valid_employee_params[:employee][:name] = nil
        valid_employee_params
      end

      it 'does not increment the Employee count' do
        expect do
          post employees_path, params: invalid_employee_params
        end.not_to change(Employee, :count)
      end

      it 'renders the new template' do
        post employees_path, params: invalid_employee_params

        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET /employee/:id/edit' do
    let(:employee) { create(:employee) }

    before do
      get edit_employee_path(employee)
    end

    it 'assigns @employee' do
      expect(assigns(:employee)).to eq(employee)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the edit template' do
      expect(response).to render_template('edit')
    end
  end

  describe 'PUT /update/:id' do
    let(:employee) { create(:employee) }

    let(:valid_employee_params) do
      {
        employee: (attributes_for :employee)
      }
    end

    context 'when updating the employee is successful' do
      let(:valid_updated_params) do
        valid_employee_params[:employee][:name] = 'new employee name'
        valid_employee_params
      end

      it 'redirect the correct place' do
        put employee_path(employee), params: valid_updated_params

        expect(response).to redirect_to(employees_path)
      end
    end

    context 'when updating the employee is unsuccessful' do
      let(:invalid_updated_params) do
        valid_employee_params[:employee][:name] = nil
        valid_employee_params
      end

      before do
        put employee_path(employee.id), params: invalid_updated_params
      end

      it 'assigns @employee' do
        expect(assigns(:employee)).to eq(employee)
      end

      it 'renders the edit template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE /employee/:id' do
    let(:employee) { create(:employee) }

    before do
      delete employee_path(employee)
    end

    it 'assigns @employee' do
      expect(assigns(:employee)).to eq(employee)
    end

    it 'redirect the correct place' do
      expect(response).to redirect_to(employees_path)
    end
  end
end
