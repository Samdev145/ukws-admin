# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Twintec S3' }
    record_type { 'water softener' }

    after(:build) do |record|
      %w[test1.png test2.png].each do |filename|
        record.photos.attach(
          io: File.open(Rails.root.join('spec', 'fixture_files', filename)),
          filename: filename,
          content_type: 'image/png'
        )
      end
    end

    trait :with_photos do
      photos do
        %w[test1.png test2.png].map do |filename|
          Rack::Test::UploadedFile.new(
            Rails.root.join('spec', 'fixture_files', filename), 'image/png'
          )
        end
      end
    end
  end
end
