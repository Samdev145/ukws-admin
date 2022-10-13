module Zoho
  class Contact

    def self.search(client, search_criteria)
      response = client.get('Contacts/search', search_criteria)
      response.body['data'].map do |record_data|
        new(record_data)
      end
    end

    def self.find_by_id(client, id)
      response = client.get("Contacts/#{id}")
      new(response.body['data'][0])
    end

    def initialize(opts)
      @opts = opts
    end
    
    def id
      @opts['id']
    end

    def full_name
      @opts['Full_Name']
    end

    def email
      @opts['Email']
    end
  end
end
