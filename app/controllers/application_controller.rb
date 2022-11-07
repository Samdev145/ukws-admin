# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user

  def authenticate_user
    redirect_to '/crm/login' if session[CRM::PROVIDER].nil? || crm_client.invalid_session?
  end

  def authenticate_calendar_client_user
    return unless session[CALENDAR::PROVIDER].nil? || calendar_client.invalid_session?

    flash[:alert] = 'Sign in using google if you want to be able to book appointments'
    redirect_to '/calendar/login'
  end

  private

  def calendar_client
    CALENDAR::Client.new(
      CALENDAR::Session.new(session[CALENDAR::PROVIDER])
    )
  end

  def crm_client
    CRM::Client.new(
      CRM::Session.new(session[CRM::PROVIDER])
    )
  end

  def file_storage_client
    FileStorage::Client.new(FileStorage::Session.new)
  end
end
