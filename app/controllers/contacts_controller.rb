# frozen_string_literal: true

class ContactsController < ApplicationController
  layout 'search', only: :index

  def index
    @session_details = session[:zoho]

    if params[:search] && params[:search].present?
      @contacts = crm_client.contacts(email: params[:search])

      if @contacts.empty?
        flash.now[:alert] = 'No contacts could be found by matching the email you provided'
      end
    end
  end

  def show
    @contact = crm_client.find_contact_by_id(params[:id])
  end

  def create
    @contact = crm_client.find_contact_by_id(params[:id])
    email_template = params[:email_template].downcase
    ContactMailer.with(contact: @contact).send("#{email_template}_email").deliver_now
  end
end
