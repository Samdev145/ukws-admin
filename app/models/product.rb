# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :main_photo do |attachable|
    attachable.variant :small, resize_to_limit: [400, 400]
    attachable.variant :medium, resize_to_limit: [600, 600]
  end
  has_one_attached :installed_photo  do |attachable|
    attachable.variant :small, resize_to_limit: [400, 400]
  end
  has_many_attached :other_photos

  validates :name, :record_type, presence: true

  def self.find_by_lowercase_name(name)
    where('lower(name) = ?', name.downcase).first
  end
end
