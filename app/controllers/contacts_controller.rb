class ContactsController < ApplicationController
  def index
    @session_details = session[:zoho]

    if params[:search]
      @contacts = crm_client.contacts(email: params[:search])
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
