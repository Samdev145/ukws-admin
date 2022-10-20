require 'rails_helper'

RSpec.describe Employee, type: :model do

  describe 'associations' do
    it { have_one_attached(:avatar) }
  end
  
  describe 'validations' do
    subject { build(:employee) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:contact_number) }
    it { should validate_presence_of(:job) }
    it { should validate_presence_of(:introduction) }

    it { should validate_uniqueness_of(:email) }
  end

  describe 'queries' do
    describe '#installers' do

      before do
        2.times { create(:employee, job: 'Installer') }
        create(:employee, job: 'head of something')
        create(:employee, job: 'head of something else')
      end

      it 'should return the installer records' do
        expect(Employee.installers.count).to eq(2)
      end
    end
  end
end
