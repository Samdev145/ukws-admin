# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :zoho, ENV['ZOHO_API_KEY'], ENV['ZOHO_SHARED_SECRET'],
           scope: 'ZohoCRM.org.ALL,ZohoCRM.modules.ALL,ZohoSearch.securesearch.READ,ZohoCRM.coql.READ'
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], scope: 'https://www.googleapis.com/auth/calendar,email'
end
