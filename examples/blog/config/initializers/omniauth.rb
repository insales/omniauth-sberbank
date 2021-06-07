# frozen_string_literal: true
require 'pry'

OmniAuth.config.logger = Rails.logger
OmniAuth.config.add_camelization 'mailru', 'MailRu'

Rails.application.config.middleware.use OmniAuth::Builder do
  def p12
    OpenSSL::PKCS12.new(p12_file.read, 'password')
  end

  def p12_file
    File.open('../yourPath/product.ru.p12', 'rb')
  end

  def client_key
    p12.key
  end

  def client_cert
    p12.certificate
  end

  provider :sberbank,
           client_id: '111111111111',
           client_secret: '111111111111',
           response_type: 'code',
           client_type: 'PRIVATE',
           client_options: { ssl: { client_key: client_key, client_cert: client_cert } },
           scope: 'openid name email mobile',
           #  callback_path: '/callback',
           grant_type: 'client_credentials'
end
