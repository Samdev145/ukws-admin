module MicrosoftOffice365
  class Folder

    def initialize(client, opts)
      @client = client
      @id = opts['id']
    end

    def get_images(type)
      children.each_with_object([]) do |child, arr|
        arr << Child.new(child) if child['name'] =~ /#{type}/
      end
    end

    def children
      @client.get("v1.0/me/drive/items/#{@id}/children").body['value']
    end
  end
end