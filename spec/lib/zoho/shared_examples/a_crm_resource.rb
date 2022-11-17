# frozen_string_literal: true

RSpec.shared_examples 'a CRM resource' do
  described_class::ATTRIBUTES.each do |attr|
    describe "##{attr.downcase}" do
      let(:crm_resouce) do
        described_class.new(resource_data)
      end

      it "returns the resources #{attr.downcase}" do
        expect(crm_resouce.send(attr.downcase)).to eq(resource_data[attr])
      end
    end
  end
end
