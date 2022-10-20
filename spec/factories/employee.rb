FactoryBot.define do
  factory :employee do
    name { 'Bob' }
    sequence(:email) { |n| "test#{n}@email.com" }
    contact_number { 12345678987 }
    job { 'Installer' }
    calendar_id { 1 }
    introduction { 'intro here about the employee' }
  end
end
