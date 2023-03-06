# frozen_string_literal: true

module Zoho
  class LeadDecorator < BaseDecorator
    def extra_notes
      "#{salt_quantity} packs of #{type_of_salt} " \
      "Salt will come with the Installer and the remaining #{salt_quantity} packs " \
      "will be delivered via our salt driver James in 7-10 working days " \
      "from when payment is received. #{customer_notes}"
    end

    def type_of_salt
      type = salt_type.first
      type == 'Curved' ? 'Mini Curved' : type
    end
  end
end
