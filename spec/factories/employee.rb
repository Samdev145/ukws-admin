# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { 'Bob' }
    sequence(:email) { |n| "test#{n}@email.com" }
    contact_number { 12_345_678_987 }
    job { 'Installer' }
    calendar_id { 1 }
    introduction { 'intro here about the employee' }
  end
end
