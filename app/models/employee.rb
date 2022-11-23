# frozen_string_literal: true

class Employee < ApplicationRecord
  has_one_attached :avatar

  scope :installers, -> { where(job: 'Installer') }
  scope :internal, -> { where(internal: true) }

  validates :name,
            :email,
            :calendar_id,
            :contact_number,
            :job,
            :introduction,
            :preferred_start_time,
            presence: true

  validates_inclusion_of :internal, in: [true, false]

  validates :email, uniqueness: true
end
