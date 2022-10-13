class ApplicationController < ActionController::Base

  private

  def calendar_client
    CALENDAR_CLIENT.new(session[:google])
  end

  def crm_client
    CRM_CLIENT.new(session[:zoho])
  end
end
