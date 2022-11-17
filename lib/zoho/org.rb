# frozen_string_literal: true

module Zoho
  class Org
    def self.find(client)
      response = client.faraday.get('org')

      return nil if response.body.nil?

      new(response.body['org'][0])
    end

    ATTRIBUTES = %w[
      domain_name
    ].freeze

    def initialize(opts)
      @opts = opts
    end

    def domain_name
      @opts['domain_name']
    end
  end
end
