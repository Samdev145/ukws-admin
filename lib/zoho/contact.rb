# frozen_string_literal: true

module Zoho
  class Contact
    def self.search(client, search_criteria)
      response = client.faraday.get('Contacts/search', search_criteria)

      return [] if response.body.nil?

      response.body['data'].map do |record_data|
        new(record_data)
      end
    end

    def self.find_by_id(client, id)
      response = client.faraday.get("Contacts/#{id}")

      return nil if response.body.nil?

      new(
        response.body['data'][0].merge(
          'org_domain_name' => client.org.domain_name
        )
      )
    end

    ATTRIBUTES = %w[
      Email
      Full_Name
      id
      org_domain_name
    ].freeze

    def initialize(opts)
      @opts = opts
    end

    ATTRIBUTES.each do |attr|
      define_method attr.downcase do
        @opts[attr]
      end
    end

    def link_address
      "https://crm.zoho.eu/crm/#{org_domain_name}/tab/Contacts/#{id}"
    end
  end
end
