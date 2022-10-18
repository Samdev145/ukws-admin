module MicrosoftOffice365
  class Child

    def initialize(opts)
      @opts = opts
    end

    def download_url
      @opts['@microsoft.graph.downloadUrl']
    end

    def download_file(path=nil)
      resp = HTTParty.get(download_url)
      File.open("#{Rails.root}#{path}/#{@opts['name']}", 'wb') { |f| f.write(resp.parsed_response) }
    end
  end
end
