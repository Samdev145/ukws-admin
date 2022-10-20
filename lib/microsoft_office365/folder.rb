module MicrosoftOffice365
  class Folder
    def initialize(client, opts)
      @client = client
      @id = opts['id']
    end

    def get_images(type)
      children.select { |child| child['name'] =~ /#{type}/ }
    end

    def children
      response = @client.get("v1.0/drives/#{ENV['OFFICE365_DRIVE_ID']}/items/#{@id}/children")
      response.body['value'].map { |child| Child.new(child) }
    end
  end
end
