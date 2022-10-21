# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Twintec S3' }
    record_type { 'water softener' }

    after(:build) do |record|
      %w[test1.jpg test2.jpg].each do |filename|
        record.photos.attach(
          io: File.open(Rails.root.join('spec', 'fixture_files', filename)),
          filename: filename,
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
