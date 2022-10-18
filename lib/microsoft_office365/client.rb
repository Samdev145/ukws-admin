require 'microsoft_office365/folder'
require 'microsoft_office365/child'

module MicrosoftOffice365
  class Client

    def initialize(session)
      @session = session
      @client = Faraday.new("#{session.api_domain}") do |f|
        f.request :json
        f.response :json
        f.request :authorization, 'bearer', session.token
      end
    end

    def find_customer(customer_name)
      resp = @client.get("v1.0/me/drive/root/search(q='#{customer_name}')")
      
      Folder.new(@client, resp.body['value'][0])
    end
  end
end
