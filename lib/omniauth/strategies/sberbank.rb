# frozen_string_literal: true

require 'omniauth/strategies/oauth2'
require 'securerandom'

module OmniAuth
  module Strategies
    # Authenticate to Sberbank utilizing OAuth 2.0 and retrieve
    # basic user information.
    # documentation available here:
    # https://developer.sberbank.ru/doc/v1/sberbank-id/info
    #
    # provider :sberbank,
    # client_id: '11111111-1111-1111-1111-1111111111111111',
    # client_secret: 'YOURSECRET',
    # response_type: 'code',
    # client_type: 'PRIVATE',
    # client_options: { ssl: { client_key: client_key, client_cert: client_cert } },
    # scope: 'openid name email mobile',
    # callback_path: '/callback',
    # grant_type: 'client_credentials'
    #
    class Sberbank < OmniAuth::Strategies::OAuth2
      class NoRawData < StandardError; end

      API_VERSION = '1.0'

      DEFAULT_SCOPE = 'openid name'

      option :name, 'sberbank'

      option :client_options,
             site: 'https://api.sberbank.ru',
             token_url: 'https://api.sberbank.ru/prod/tokens/v3/oidc',
             authorize_url: 'https://online.sberbank.ru/CSAFront/oidc/authorize.do'

      option :authorize_options, %i[scope response_type client_type client_id state nonce]

      option :redirect_url, nil

      uid { raw_info['sub'].to_s }

      # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      info do
        {
          name: "#{raw_info['family_name']} #{raw_info['given_name']} #{raw_info['middle_name']}".strip,
          phone_number: raw_info['phone_number'],
          email: raw_info['email'],
          first_name: raw_info['family_name'],
          last_name: raw_info['given_name'],
          middle_name: raw_info['middle_name'],
          id: raw_info['sub'],
          client_host: raw_info['state'],
          provider: options.name
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      # https://developer.sberbank.ru/doc/v1/sberbank-id/datareq
      def raw_info
        access_token.options[:mode] = :header
        @raw_info ||= begin
          state = request.params['state']
          result = access_token.get('/prod/sberbankid/userinfo/v5/', headers: info_headers).parsed
          unless result['aud'] == options.client_id
            raise ArgumentError, "aud in Sber response not equal clien_id. aud = #{result['aud']}"
          end

          result['state'] = state
          result
        end
      end

      # https://developer.sberbank.ru/doc/v1/sberbank-id/authcodereq
      def authorize_params
        super.tap do |params|
          %w[state scope response_type client_type client_id nonce].each do |v|
            next unless request.params[v]

            params[v.to_sym] = request.params[v]
          end
          params[:scope] ||= DEFAULT_SCOPE
          # if you want redirect to other host and save old host
          state = session['omniauth.origin'] || env['HTTP_REFERER']
          params[:state] = state
          session['omniauth.state'] = state
          params[:nonce] = SecureRandom.hex(16)
        end
      end

      def token_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private

      def params
        {
          fields: info_options,
          lang: lang_option,
          https: https_option,
          v: API_VERSION
        }
      end

      def query_string
        params = request.params.except('state', 'nonce', 'code')
        request.query_string.empty? ? '' : "?#{params.to_query}"
      end

      def info_options
        # https://developer.sberbank.ru/doc/v1/sberbank-id/dataanswerparametrs
        fields = %w[
          sub family_name given_name middle_name birthdate email phone_number
          address_reg identification inn snils gender
        ]
        fields.concat(options[:info_fields].split(',')) if options[:info_fields]
        fields.join(',')
      end

      def lang_option
        options[:lang] || ''
      end

      def https_option
        options[:https] || 0
      end

      # https://developer.sberbank.ru/doc/v1/sberbank-id/accessidtokens
      def build_access_token
        options.token_params.update(headers: access_token_headers)
        super
      end

      def image_url
        case options[:image_size]
        when 'mini'
          raw_info['photo_50']
        when 'bigger'
          raw_info['photo_100']
        when 'bigger_x2'
          raw_info['photo_200']
        when 'original'
          raw_info['photo_200_orig']
        when 'original_x2'
          raw_info['photo_400_orig']
        else
          raw_info['photo_50']
        end
      end

      def location
        country = raw_info.fetch('country', {})['title']
        city = raw_info.fetch('city', {})['title']
        @location ||= [country, city].compact.join(', ')
      end

      def callback_phase
        super
      rescue NoRawData => e
        fail!(:no_raw_data, e)
      end

      def access_token_headers
        OmniAuth.logger.send(:debug, "YOUR RQUID #{rquid}")
        {
          'rquid' => rquid,
          'x-ibm-client-id' => options.client_id,
          'accept' => 'application/json'
        }
      end

      def info_headers
        {
          'x-introspect-rquid' => rquid,
          'x-ibm-client-id' => options.client_id,
          'accept' => 'application/json',
          'Authorization' => "Bearer #{access_token.token}"
        }
      end

      def rquid
        @rquid ||= SecureRandom.hex(16)
      end
    end
  end
end
