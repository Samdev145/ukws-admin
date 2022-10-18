require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class MicrosoftOffice365 < OmniAuth::Strategies::OAuth2
      option :name, :microsoft_office365

      DEFAULT_SCOPE="openid User.Read Contacts.Read Files.Read.All"

      option :client_options, {
        site:          "https://login.microsoftonline.com",
        authorize_url: "/common/oauth2/v2.0/authorize",
        token_url:     "/common/oauth2/v2.0/token"
      }

      option :authorize_options, %w[scope domain_hint]

      uid { raw_info["id"] }

      info do
        {
          email:        raw_info["mail"] || raw_info["userPrincipalName"],
          display_name: raw_info["displayName"],
          first_name:   raw_info["givenName"],
          last_name:    raw_info["surname"],
          api_domain:   'https://graph.microsoft.com',
          token:        access_token.token,
          id_token:  access_token.params.id_token,
          expires_at:   Time.now.to_i + access_token.expires_in
        }
      end

      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get("https://graph.microsoft.com/v1.0/me").parsed
      end

      def authorize_params
        super.tap do |params|
          %w[display domain_hint scope auth_type].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end