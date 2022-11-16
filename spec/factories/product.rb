# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Twintec S3' }
    record_type { 'water softener' }

    after(:build) do |record|
      record.main_photo.attach(
        io: File.open(Rails.root.join('spec', 'fixture_files', 'main_photo.png')),
        filename: 'main_photo.png',
        content_type: 'image/png'
      )

      record.installed_photo.attach(
        io: File.open(Rails.root.join('spec', 'fixture_files', 'installed_photo.png')),
        filename: 'installed_photo.png',
        content_type: 'image/png'
      )
    end

    trait :with_photos do
      main_photo do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixture_files', 'main_photo.png'), 'image/png'
        )
      end

      installed_photo do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixture_files', 'installed_photo.png'), 'image/png'
        )
      end

      other_photos do
        %w[main_photo.png installed_photo.png].map do |filename|
          Rack::Test::UploadedFile.new(
            Rails.root.join('spec', 'fixture_files', filename), 'image/png'
          )
        end
      end
    end
  end
end
