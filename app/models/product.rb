# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :photos

  validates :name, :record_type, :photos, presence: true

  def find_attachment_by_filename(filename)
    photos_attachments.joins(:blob).where('filename LIKE ?', "#{filename}.%").first
  end
end
