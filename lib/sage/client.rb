# frozen_string_literal: true

module Sage
  class Client
    attr_reader :faraday

    def initialize(session)
      @session = session

      @faraday = Faraday.new("#{session.api_domain}/v3.1/") do |f|
        f.request :json
        f.response :json
        f.request :authorization, 'Bearer', -> { session.auth_token }
      end
    end

    def find_product(product_name)
      Product.find_by_name(self, product_name)
    end

    def find_or_create_customer(customer_details)
      Customer.find_or_create(self, customer_details)
    end

    def create_invoice(customer:, invoice_date:, products:)
      opts = {
        customer: customer,
        invoice_date: invoice_date,
        products: products
      }

      SalesInvoice.create(self, opts)
    end

    def invalid_session?
      session.invalid_session?
    end

    private

    attr_reader :session
  end
end
