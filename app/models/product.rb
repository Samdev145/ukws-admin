class Product < ApplicationRecord
  has_many_attached :photos

  def find_attachment_by_filename(filename)
    photos_attachments.joins(:blob).where("filename LIKE ?", "#{filename}.%").first
  end
end
