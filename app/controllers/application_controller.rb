# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user
  helper_method :active_user_session?

  def authenticate_user
    redirect_to login_path(:crm) if user_not_logged_in?
  end

  def active_user_session?
    !user_not_logged_in?
  end

  def authenticate_calendar_client_user
    return unless session[CALENDAR::PROVIDER].nil? || calendar_client.invalid_session?

    flash[:alert] = 'Sign in using google if you want to be able to book appointments'
    redirect_to login_path(:calendar)
  end

  def authenticate_accounts_client_user
    return unless session[ACCOUNTING::PROVIDER].nil? || accounts_client.invalid_session?

    flash[:alert] = "Sign in using #{ACCOUNTING::FRIENDLY_NAME} if you want to be able to create invoices"
    redirect_to login_path(:accounting)
  end

  private

  def user_not_logged_in?
    session[CRM::PROVIDER].nil? || crm_client.invalid_session?
  end

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

  def accounts_client
    acc = ACCOUNTING::Client.new(
      ACCOUNTING::Session.new(session[ACCOUNTING::PROVIDER])
    )
  end

  def file_storage_client
    FileStorage::Client.new(FileStorage::Session.new)
  end
end
