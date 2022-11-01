# frozen_string_literal: true

class Appointment < ApplicationRecord
  belongs_to :employee

  validates :employee,
            :customer_email,
            :customer_type,
            :start_time,
            :end_time,
            :crm_id,
            presence: true
end
