require 'zoho/client'
require 'zoho/contact'
require 'zoho/lead'

module Zoho
  class Client
    def initialize(session)
      @session = session
      @client = Faraday.new("#{session['api_domain']}/crm/v3/") do |f|
        f.request :json
        f.response :json
        f.request :authorization, 'Bearer', session['token']
      end
    end

    def contacts(search_criteria)
      Contact.search(client, search_criteria)
    end

    def find_contact_by_id(id)
      Contact.find_by_id(client, id)
    end

    def leads(search_criteria)
      Lead.search(client, search_criteria)
    end

    def find_lead_by_id(id)
      Lead.find_by_id(client, id)
    end

    def invalid_session?
      !valid_session?
    end

    private

    attr_reader :client, :session

    def valid_session?
      return true unless token_expired?
      refreshed_token?
    end

    def refreshed_token?
      conn = Faraday.new("https://accounts.zoho.eu") do |f|
        f.response :json
      end

      resp = conn.post('/oauth/v2/token') do |req|
        req.headers['Content-Type'] = 'application/json'
        req.params = {
          refresh_token: session['refresh_token'],
          client_id: ENV['ZOHO_API_KEY'],
          client_secret: ENV['ZOHO_SHARED_SECRET'],
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
