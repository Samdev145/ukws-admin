# frozen_string_literal: true

class Employee < ApplicationRecord
  has_one_attached :avatar

  scope :installers, -> { where(job: 'Installer') }

  validates :name, :email, :calendar_id, :contact_number, :job, :introduction, presence: true
  validates :email, uniqueness: true
end
