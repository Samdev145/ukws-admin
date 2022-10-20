require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class GoogleOauth2 < OmniAuth::Strategies::OAuth2
      info do
        prune!(
          token: credentials['token'],
          refresh_token: credentials['refresh_token'],
          expires_at: credentials['expires_at'],
          name: raw_info['name'],
          email: verified_email,
          unverified_email: raw_info['email'],
          email_verified: raw_info['email_verified'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name'],
          image: image_url,
          urls: {
            google: raw_info['profile']
          }
        )
      end
    end
  end
end
