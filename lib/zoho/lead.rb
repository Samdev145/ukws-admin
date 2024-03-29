# frozen_string_literal: true

module Zoho
  class Lead
    def self.search(client, search_criteria)
      response = client.faraday.get('Leads/search', search_criteria)

      return [] if response.body.nil?

      response.body['data'].map do |record_data|
        new(record_data)
      end
    end

    def self.find_by_id(client, id)
      response = client.faraday.get("Leads/#{id}")

      return nil if response.body.nil?

      new(
        response.body['data'][0].merge(
          'org_domain_name' => client.org.domain_name
        )
      )
    end

    ATTRIBUTES = %w[
      City
      Country
      Customer_Notes
      Incoming_Mains_Location
      Drinking_Taps
      Drinking_Water_Filter
      Email
      Extra_Salt
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
      org_domain_name
      Phone
      Zip_Code
      Salt_Quantity
      Salt_type
      Softener_warranty_details
      Street
      Survey_Notes1
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
      addr = street
      addr += ", #{city}" if city
      addr += ", #{country}" if country
      addr += ", #{zip_code}" if zip_code
      addr
    end

    def phone_number
      mobile || phone
    end

    def survey_notes
      survey_notes1
    end

    def link_address
      "https://crm.zoho.eu/crm/#{org_domain_name}/tab/Leads/#{id}"
    end

    def products_purchased
      [].tap do |products|
        products << water_softener_model if water_softener_model
        products << drinking_taps if drinking_taps
        products << drinking_water_filter if drinking_water_filter
        products << salt_quantity if salt_quantity
      end
    end
  end
end
