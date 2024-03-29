# frozen_string_literal: true

require 'omniauth-oauth2'

# taken from - https://github.com/Jetbuilt/omniauth-sageone/blob/main/lib/omniauth/strategies/sage_one.rb

module OmniAuth
  module Strategies
    class SageOne < OmniAuth::Strategies::OAuth2
      option :client_options,
             authorize_url: 'https://www.sageone.com/oauth2/auth/central',
             token_url: 'https://oauth.accounting.sage.com/token'

      option :authorize_params,
             response_type: 'code',
             filter: 'apiv3.1'

      uid do
        access_token['requested_by_id']
      end

      credentials do
        {
          resource_owner_id: access_token['resource_owner_id']
        }
      end

      info do
        {
          country: country,
          api_domain: 'https://api.accounting.sage.com',
          token: access_token.token,
          refresh_token: access_token.refresh_token,
          expires_at: access_token.expires_at
        }
      end

      # Override this method to remove the query string from the callback_url because SageOne
      # requires an exact match
      def callback_url
        super.split('?').first
      end

      protected

      def country
        request.env ? request[:country].try(:downcase) : options.client_options[:country]
      end
    end
  end
end

OmniAuth.config.add_camelization 'sageone', 'SageOne'