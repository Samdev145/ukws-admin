require 'microsoft_office365/session'
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

    def find_folder(folder_path)
      resp = @client.get("v1.0/drives/#{ENV['OFFICE365_DRIVE_ID']}/root:#{folder_path}")
      Folder.new(@client, resp.body)
    end
  end
end
