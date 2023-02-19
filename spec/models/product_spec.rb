# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product do
  describe 'associations' do
    it { is_expected.to have_one_attached(:main_photo) }
    it { is_expected.to have_one_attached(:installed_photo) }
    it { is_expected.to have_many_attached(:other_photos) }
  end

  describe 'validations' do
    subject { create(:product) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:record_type) }
  end
end
