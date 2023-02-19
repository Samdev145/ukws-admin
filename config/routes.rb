# frozen_string_literal: true

Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  root 'dashboard#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get '/:adapter/login', to: 'sessions#new', as: :login
  get '/logout', to: 'sessions#destroy'

  resources :contacts
  resources :leads do
    member do
      post :send_email
      post :book_appointment
      post :send_quotation
      get :installation_email
      get :quotation_email
    end
  end
  resources :employees
  resources :products
end
