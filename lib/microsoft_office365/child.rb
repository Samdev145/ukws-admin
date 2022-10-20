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

    def download_file_to(path = nil)
      resp = HTTParty.get(download_url)
      File.open("#{Rails.root}#{path}/#{name}", 'wb') { |f| f.write(resp.parsed_response) }
    end
  end
end
