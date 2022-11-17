# frozen_string_literal: true

module Zoho
  class Client
    attr_reader :faraday

    def initialize(session)
      @session = session
      @faraday = Faraday.new("#{session.api_domain}/crm/v3/") do |f|
        f.request :json
        f.response :json
        f.request :authorization, 'Bearer', session.token
      end
    end

    def contacts(search_criteria)
      Contact.search(self, search_criteria)
    end

    def find_contact_by_id(id)
      Contact.find_by_id(self, id)
    end

    def leads(search_criteria)
      Lead.search(self, search_criteria)
    end

    def find_lead_by_id(id)
      Lead.find_by_id(self, id)
    end

    def org
      @org ||= Org.find(self)
    end

    def invalid_session?
      session.invalid_session?
    end

    private

    attr_reader :session
  end
end
