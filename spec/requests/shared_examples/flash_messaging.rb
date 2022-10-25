# frozen_string_literal: true

RSpec.shared_context 'flash messaging' do
  let(:flash) do
    ActionDispatch::Flash::FlashHash.new
  end

  before do
    allow_any_instance_of(described_class).to receive(:flash).and_return(flash)
  end
end
