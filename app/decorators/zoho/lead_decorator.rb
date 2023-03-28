# frozen_string_literal: true

module Zoho
  class LeadDecorator < BaseDecorator
    def extra_salt_notes
      "#{salt_quantity} packs of #{type_of_salt} " \
      "salt will come with the installer and the remaining #{extra_salt} packs " \
      "will be delivered via our salt driver James in 7-10 working days " \
      "from when payment is received."
    end

    def type_of_salt
      type = salt_type.first
      type == 'Curved' ? 'Mini Curved' : type
    end
  end
end
