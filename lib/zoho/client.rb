require 'zoho/client'
require 'zoho/contact'
require 'zoho/lead'

module Zoho
  class Client

    def initialize(session)
      @client = Faraday.new("#{session['api_domain']}/crm/v3/") do |f|
        f.request :json
        f.response :json
        f.request :authorization, 'Bearer', session['token']
      end
    end

    def contacts(search_criteria)
      Contact.search(@client, search_criteria)
    end

    def find_contact_by_id(id)
      Contact.find_by_id(@client, id)
    end

    def leads(search_criteria)
      Lead.search(@client, search_criteria)
    end

    def find_lead_by_id(id)
      Lead.find_by_id(@client, id)
    end
  end
end
