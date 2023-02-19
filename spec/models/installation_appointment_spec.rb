# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstallationAppointment do
  describe 'associations' do
    it { is_expected.to belong_to(:employee) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:employee) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_presence_of(:customer_type) }
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:crm_id) }
  end
end
