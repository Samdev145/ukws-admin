# frozen_string_literal: true

module MicrosoftOffice365
  class Session
    SCOPE = 'https://graph.microsoft.com/.default'
    API_DOMAIN = 'https://graph.microsoft.com'
    LOGIN_URL = 'https://login.microsoftonline.com/'

    def initialize
      authenticate
    end

    def api_domain
      API_DOMAIN
    end

    def token
      @access_token
    end

    private

    def authenticate
      conn = Faraday.new(LOGIN_URL)

      response = conn.post("#{ENV['OFFICE365_TENANT_ID']}/oauth2/v2.0/token") do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {
          grant_type: 'client_credentials',
          client_id: ENV['OFFICE365_KEY'],
          client_secret: ENV['OFFICE365_SECRET'],
          scope: SCOPE
        }
      end

      @access_token = JSON.parse(response.body)['access_token']
    end
  end
end
