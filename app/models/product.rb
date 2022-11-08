# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :photos

  validates :name, :record_type, :photos, presence: true

  def self.main_photo_for(product_name)
    record = where('lower(name) = ?', product_name.downcase).first
    return nil if record.nil?

    record.find_attachment_by_filename(:main_photo)
  end

  def find_attachment_by_filename(filename)
    photos_attachments.joins(:blob).where('filename LIKE ?', "#{filename}.%").first
  end
end
