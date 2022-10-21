# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :zoho, ENV.fetch('ZOHO_API_KEY'), ENV.fetch('ZOHO_SHARED_SECRET'),
           scope: 'ZohoCRM.org.ALL,ZohoCRM.modules.ALL,ZohoSearch.securesearch.READ,ZohoCRM.coql.READ'
  provider :google_oauth2, ENV.fetch('GOOGLE_CLIENT_ID'), ENV.fetch('GOOGLE_CLIENT_SECRET'), scope: 'https://www.googleapis.com/auth/calendar,email'
end
