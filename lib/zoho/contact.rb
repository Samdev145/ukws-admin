module Zoho
  class Contact
    def self.search(client, search_criteria)
      response = client.get('Contacts/search', search_criteria)

      return [] if response.body.nil?

      response.body['data'].map do |record_data|
        new(record_data)
      end
    end

    def self.find_by_id(client, id)
      response = client.get("Contacts/#{id}")

      new(response.body['data'][0])
    end

    ATTRIBUTES = %w[
      Email
      Full_Name
      id
    ]

    def initialize(opts)
      @opts = opts
    end

    ATTRIBUTES.each do |attr|
      define_method attr.downcase do
        @opts[attr]
      end
    end
  end
end
