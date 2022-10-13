module Zoho
  class Lead

    def self.search(client, search_criteria)
      response = client.get('Leads/search', search_criteria)

      return [] if response.body.nil?

      response.body['data'].map do |record_data|
        new(record_data)
      end
    end

    def self.find_by_id(client, id)
      response = client.get("Leads/#{id}")
      new(response.body['data'][0])
    end

    ATTRIBUTES = %w(
      City
      Country
      Drinking_Tap
      Drinking_Water_Filter
      Email
      Full_Name
      id
      Installation_date
      Installation_Type
      Installer
      Phone
      Postal_Code
      Salt_Quantity
      Softener_warranty_details
      Street
      Total Cost
      Water_Softener_Model
      what3words
    )

    attr_reader :opts

    def initialize(opts)
      @opts = opts
    end
    
    ATTRIBUTES.each do |attr|
      define_method attr.downcase do
        @opts[attr]
      end
    end

    def address
      "#{street}, #{city}, #{country}, #{postal_code}"
    end
  end
end
