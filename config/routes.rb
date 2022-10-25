# frozen_string_literal: true

Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all, as: :not_found
  match '/500', to: 'errors#internal_server_error', via: :all

  get 'products/index'
  root 'dashboard#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'

  resources :contacts
  resources :leads do
    member do
      post :send_email
      post :book_appointment
    end
  end
  resources :employees
  resources :products
end
