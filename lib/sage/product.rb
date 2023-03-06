# frozen_string_literal: true

module Sage
  class Product
    URL_ENDPOINT = 'products'
    FIND_ATTRIBUTES = 'sales_ledger_account,sales_prices'

    def self.find_by_name(client, name)
      response = client.faraday.get(
        URL_ENDPOINT, { search: name, attributes: FIND_ATTRIBUTES }
      )

      raise RecordNotFoundError, "Unable to find product #{name}. Resonse Status: #{response.status}" if response.body['$items'].empty?

      new(response.body['$items'].first)
    end

    def initialize(opts)
      @opts = opts
    end

    def id
      @opts['id']
    end

    def displayed_as
      @opts['displayed_as']
    end

    def sales_price
      @opts['sales_prices'].detect { |price| price['displayed_as'] == 'Sales Price' }['price']
    end

    def sales_ledger_account_id
      @opts['sales_ledger_account']['id']
    end
  end
end
