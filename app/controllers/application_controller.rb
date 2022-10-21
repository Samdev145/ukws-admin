# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user

  def authenticate_user
    redirect_to :login if session[CRM::Provider].nil? || crm_client.invalid_session?
  end

  private

  def calendar_client
    CALENDAR_CLIENT.new(session[CALENDAR_CLIENT::Provider])
  end

  def crm_client
    CRM::Client.new(CRM::Session.new(session[CRM::Provider]))
  end

  def file_storage_client
    FileStorage::Client.new(FileStorage::Session.new)
  end
end
