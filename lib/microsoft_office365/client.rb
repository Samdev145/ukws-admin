# frozen_string_literal: true

module MicrosoftOffice365
  class Client
    def initialize(session)
      @session = session
      @client = Faraday.new(session.api_domain.to_s) do |f|
        f.request :json
        f.response :json
        f.request :authorization, 'bearer', session.token
      end
    end

    def find_folder(folder_path)
      resp = @client.get("v1.0/drives/#{ENV.fetch('OFFICE365_DRIVE_ID')}/root:#{folder_path}")
      Folder.new(@client, resp.body)
    end
  end
end
