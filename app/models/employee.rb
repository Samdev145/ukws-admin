# frozen_string_literal: true

class Employee < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [400, 400]
  end

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

  def self.find_by_lowercase_name(name)
    where('lower(name) = ?', name.downcase).first
  end
end
