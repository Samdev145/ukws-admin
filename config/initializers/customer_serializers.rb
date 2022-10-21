# frozen_string_literal: true

Rails.autoloaders.main.ignore("#{Rails.root}/app/serializers")

require 'zoho_lead_serializer'
Rails.application.config.active_job.custom_serializers << ZohoLeadSerializerSerializer
