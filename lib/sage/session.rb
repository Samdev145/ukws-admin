# frozen_string_literal: true

module Sage
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

    def auth_token
      valid_session?
      token
    end

    private

    attr_reader :session

    def valid_session?
      return true unless token_expired?

      refreshed_token?
    end

    def refreshed_token?
      resp = request_refresh_token

      return false if resp.body['access_token'].nil?

      session['token'] = resp.body['access_token']
      session['refresh_token'] = resp.body['refresh_token']
      session['expires_at'] = (Time.zone.now + resp.body['expires_in'].seconds).to_i

      true
    end

    def request_refresh_token
      conn = Faraday.new('https://oauth.accounting.sage.com') do |f|
        f.response :json
      end

      conn.post('/token') do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.headers['Accept'] = 'application/json'
        req.body = URI.encode_www_form(refresh_token_request_params)
      end
    end

    def refresh_token_request_params
      {
        refresh_token: session['refresh_token'],
        client_id: ENV.fetch('SAGE_CLIENT_ID'),
        client_secret: ENV.fetch('SAGE_CLIENT_SECRET'),
        grant_type: 'refresh_token'
      }
    end

    def token_expired?
      Time.zone.now > Time.zone.at(session['expires_at'])
    end
  end
end
