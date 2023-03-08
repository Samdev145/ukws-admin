# frozen_string_literal: true

class Translation < ApplicationRecord
  scope :from_crm_to_accounts,   -> { where(translation_type: 'zoho to sage') }
  scope :from_store_to_accounts, -> { where(translation_type: 'woocommerce to sage') }

  def type
    case translation_type
    when 'zoho to sage' then 'crm'
    when 'woocommerce to sage' then 'store'
    end
  end
end
