# frozen_string_literal: true

module MicrosoftOffice365
  class Child
    def initialize(opts)
      @opts = opts
    end

    def name
      @opts['name']
    end

    def download_url
      @opts['@microsoft.graph.downloadUrl']
    end

    def download_file
      HTTParty.get(download_url)
    end
  end
end
