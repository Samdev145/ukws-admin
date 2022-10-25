# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :request do
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

  describe 'GET /products' do
    before do
      get products_path
    end

    it 'assigns @products' do
      products = Product.all
      expect(assigns(:products)).to eq(products)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET /products/new' do
    before do
      get new_product_path
    end

    it 'assigns @product' do
      expect(assigns(:product)).to be_a(Product)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end
  end

  describe 'POST /products' do
    let(:valid_product_params) do
      {
        product: (attributes_for :product, :with_photos)
      }
    end

    context 'when creating the product is successful' do
      it 'increments the Product count by 1' do
        expect do
          post products_path, params: valid_product_params
        end.to change(Product, :count).by(1)
      end

      it 'redirect the correct place' do
        post products_path, params: valid_product_params

        expect(response).to redirect_to(assigns(:product))
      end
    end

    context 'when creating the product is unsuccessful' do
      let(:invalid_product_params) do
        valid_product_params[:product][:name] = nil
        valid_product_params
      end

      it 'does not increment the Product count' do
        expect do
          post products_path, params: invalid_product_params
        end.not_to change(Product, :count)
      end

      it 'renders the new template' do
        post products_path, params: invalid_product_params

        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET /product/:id' do
    let(:product) do
      create(:product)
    end

    before do
      get product_path(product)
    end

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe 'GET /product/:id/edit' do
    let(:product) { create(:product) }

    before do
      get edit_product_path(product)
    end

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the edit template' do
      expect(response).to render_template('edit')
    end
  end

  describe 'PUT /update/:id' do
    let(:product) { create(:product) }

    let(:valid_product_params) do
      {
        product: (attributes_for :product, :with_photos)
      }
    end

    context 'when updating the product is successful' do
      let(:valid_updated_params) do
        valid_product_params[:product][:name] = 'new product name'
        valid_product_params
      end

      it 'redirect the correct place' do
        put product_path(product), params: valid_updated_params

        expect(response).to redirect_to(assigns(:product))
      end
    end

    context 'when updating the product is unsuccessful' do
      let(:invalid_updated_params) do
        valid_product_params[:product][:name] = nil
        valid_product_params
      end

      before do
        put product_path(product.id), params: invalid_updated_params
      end

      it 'assigns @product' do
        expect(assigns(:product)).to eq(product)
      end

      it 'renders the edit template' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE /product/:id' do
    let(:product) { create(:product) }

    before do
      delete product_path(product)
    end

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'redirect the correct place' do
      expect(response).to redirect_to(products_path)
    end
  end
end
