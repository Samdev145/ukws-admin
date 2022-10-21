# frozen_string_literal: true

module Zoho
  class Session
    def initialize(session)
      @session = session
    end

    def api_domain
      session['api_domain']
    end

    def token
      session['token']
    end

    def invalid_session?
      !valid_session?
    end

    private

    attr_reader :session

    def valid_session?
      return true unless token_expired?

      refreshed_token?
    end

    def refreshed_token?
      conn = Faraday.new('https://accounts.zoho.eu') do |f|
        f.response :json
      end

      resp = conn.post('/oauth/v2/token') do |req|
        req.headers['Content-Type'] = 'application/json'
        req.params = {
          refresh_token: session['refresh_token'],
          client_id: ENV.fetch('ZOHO_API_KEY'),
          client_secret: ENV.fetch('ZOHO_SHARED_SECRET'),
          grant_type: 'refresh_token'
        }
      end

      return false if resp.body['access_token'].nil?

      session['token'] = resp.body['access_token']
      session['expires_at'] = (Time.zone.now + resp.body['expires_in'].seconds).to_i

      true
    end

    def token_expired?
      Time.zone.now > Time.zone.at(session['expires_at'])
    end
  end
end
