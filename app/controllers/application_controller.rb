class ApplicationController < ActionController::Base

  private

  def calendar_client
    CALENDAR_CLIENT.new(session[CALENDAR_CLIENT::Provider])
  end

  def crm_client
    CRM_CLIENT.new(session[CRM_CLIENT::Provider])
  end
end
