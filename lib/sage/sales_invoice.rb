# frozen_string_literal: true

# could run a background job to update from woocomerce

module Sage
  class SalesInvoice
    URL_ENDPOINT = 'sales_invoices'
    TAX_RATE = 'GB_STANDARD'
    INVOICE_STATUS = 'DRAFT'

    def self.create(client, opts)
      customer = opts[:customer]
      products = opts[:products]
      invoice_date = opts[:invoice_date]

      response = client.faraday.post(
        URL_ENDPOINT,
        generate_payload(customer, invoice_date, products)
      )

      raise RecordNotCreatedError, "Unable to create SalesInvoice. Resonse Status: #{response.status}" if response.body.nil?

      new(response.body)
    end

    def self.generate_payload(customer, invoice_date, products)
      {
        sales_invoice: {
          contact_id: customer.id,
          date: invoice_date,
          invoice_lines: invoice_lines(products)
        }
      }
    end

    def self.invoice_lines(products)
      products.map do |h|
        {
          description: h[:product].displayed_as,
          product_id: h[:product].id,
          ledger_account_id: h[:product].sales_ledger_account_id,
          quantity: h[:quantity],
          unit_price: h[:product].sales_price,
          tax_rate_id: TAX_RATE,
          status_id: INVOICE_STATUS
        }
      end
    end

    def initialize(opts)
      @opts = opts
    end
  end
end
