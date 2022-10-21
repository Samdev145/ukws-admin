# frozen_string_literal: true

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

    ATTRIBUTES = %w[
      City
      Country
      Incoming_Mains_Location
      Drinking_Tap
      Drinking_Water_Filter
      Email
      Full_Name
      Heating_System
      Household_Size
      How_Many_Bathrooms
      id
      Installation_date
      Incoming_Main_Size
      Installation_Type
      Installed_by
      Mobile
      Phone
      Postal_Code
      Salt_Quantity
      Salt_type
      Softener_warranty_details
      Street
      Survey_Notes
      Total_Cost
      Water_Softener_Model
      what3words
    ].freeze

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
