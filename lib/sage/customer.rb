# frozen_string_literal: true

module Sage
  class Customer
    URL_ENDPOINT = 'contacts'
    CONTACT_TYPE = 'CUSTOMER'
    ADDRESS_TYPE = 'Sales'

    def self.find_by_email(client, email)
      response = client.faraday.get(
        URL_ENDPOINT, { email: email }
      )

      record = response.body['$items'].first

      return nil if record.nil?

      new(record)
    end

    def self.find_or_create(client, customer_details)
      response = find_by_email(client, customer_details[:email])

      return response unless response.nil?

      response = client.faraday.post(
        URL_ENDPOINT, generate_payload(customer_details)
      )

      raise RecordNotCreatedError, "Unable to create Customer. Resonse Status: #{response.status}" if response.body.nil?

      new(response.body)
    end

    def self.generate_payload(customer_details)
      {
        contact: {
          contact_type_ids: [CONTACT_TYPE],
          name: customer_details[:name],
          main_contact_person: {
            email: customer_details[:email],
            telephone: customer_details[:phone_number]
          },
          main_address: {
            address_type_id: ADDRESS_TYPE,
            address_line_1: customer_details[:address],
            city: customer_details[:city],
            postal_code: customer_details[:postcode]
          }
        }
      }
    end

    def initialize(opts)
      @opts = opts
    end

    def id
      @opts['id']
    end

    def main_address
      @opts['main_address']
    end
  end
end
