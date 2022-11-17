# frozen_string_literal: true

class ContactsController < ApplicationController
  def index
    @session_details = session[:zoho]

    if params[:search]&.present?
      @contacts = crm_client.contacts(email: params[:search])

      flash.now[:alert] = 'No contacts could be found by matching the email you provided' if @contacts.empty?
    end
  end

  def show
    @contact = crm_client.find_contact_by_id(params[:id])

    render 'errors/not_found', status: '404' if @contact.nil?
  end
end
