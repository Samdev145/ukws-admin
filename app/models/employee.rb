class Employee < ApplicationRecord
  has_one_attached :avatar

  scope :installers, -> { where(job: 'Installer') }
end
