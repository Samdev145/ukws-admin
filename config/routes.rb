# frozen_string_literal: true

Rails.application.routes.draw do
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
