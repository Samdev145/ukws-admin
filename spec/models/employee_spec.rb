# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'associations' do
    it { have_one_attached(:avatar) }
  end

  describe 'validations' do
    subject { build(:employee) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:contact_number) }
    it { is_expected.to validate_presence_of(:job) }
    it { is_expected.to validate_presence_of(:introduction) }

    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'queries' do
    describe '#installers' do
      before do
        create_list(:employee, 2, job: 'Installer')
        create(:employee, job: 'head of something')
        create(:employee, job: 'head of something else')
      end

      it 'returns the installer records' do
        expect(Employee.installers.count).to eq(2)
      end
    end
  end
end
