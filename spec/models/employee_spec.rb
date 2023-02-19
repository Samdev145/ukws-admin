# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee do
  describe 'associations' do
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'validations' do
    subject { build(:employee) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:contact_number) }
    it { is_expected.to validate_presence_of(:job) }
    it { is_expected.to validate_presence_of(:introduction) }
    it { is_expected.to validate_presence_of(:preferred_start_time) }

    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'queries' do
    describe '.internal' do
      before do
        create(:employee, internal: false)
        create(:employee, internal: true)
        create(:employee, internal: true)
      end

      it 'returns the correct number of internal staff records' do
        expect(described_class.internal.count).to eq(2)
      end
    end

    describe '#installers' do
      before do
        create_list(:employee, 2, job: 'Installer')
        create(:employee, job: 'head of something')
        create(:employee, job: 'head of something else')
      end

      it 'returns the installer records' do
        expect(described_class.installers.count).to eq(2)
      end
    end
  end
end
