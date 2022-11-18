# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { 'Bob' }
    sequence(:email) { |n| "test#{n}@email.com" }
    contact_number { 12_345_678_987 }
    preferred_start_time { '08:30:00' }
    job { 'Installer' }
    calendar_id { 1 }
    introduction { 'intro here about the employee' }

    after(:build) do |record|
      record.avatar.attach(
        io: File.open(Rails.root.join('spec', 'fixture_files', 'avatar.png')),
        filename: 'avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
