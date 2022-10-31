# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to have_many_attached(:photos) }
  end

  describe 'validations' do
    subject { create(:product) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:record_type) }
    it { is_expected.to validate_presence_of(:photos) }
  end

  describe 'queries' do
    describe '.main_photo_for' do
      let(:product) { create(:product) }

      it 'returns the correct image' do
        image = Product.main_photo_for(product.name)

        expect(image.filename.to_s).to eq('main_photo.png')
      end

      context 'when the product does not exist' do
        it 'returns nil' do
          image = Product.main_photo_for('non existent product name')

          expect(image).to be_nil
        end
      end
    end

    describe '#find_attachment_by_filename' do
      let(:product) { create(:product) }

      %w[main_photo other].each do |filename|
        context "when trying to find image #{filename}" do
          it 'returns the correct image' do
            image = product.find_attachment_by_filename(filename)

            expect(image.filename.to_s).to match(/#{filename}.png/)
          end
        end
      end
    end
  end
end
