# frozen_string_literal: true

module Sage
  class Address
    URL_ENDPOINT = 'addresses'
    ADDRESS_TYPE = 'Sales'

    def self.create(client, address_details)
      response = client.faraday.post(URL_ENDPOINT, generate_payload(address_details))

      return nil if response.body.nil?

      new(response.body)
    end

    def self.update(client, address_details)
      response = client.faraday.put(URL_ENDPOINT, generate_payload(address_details))

      return nil if response.body.nil?

      new(response.body)
    end

    def self.generate_payload(address_details)
      {
        address: {
          contact_id: address_details[:contact_id],
          is_main_address: true,
          address_type_id: ADDRESS_TYPE,
          address_line_1: address_details[:address],
          city: address_details[:city],
          postal_code: address_details[:postcode]
        }
      }
    end

    def initialize(opts)
      @opts = opts
    end
  end
end
