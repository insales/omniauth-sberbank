require 'pry'
# require 'uri'
# require 'openssl'
# require 'net/http'

class WelcomeController < ApplicationController
  def index
    # url = URI("https://dev.api.sberbank.ru/ru/prod/tokens/v2/oauth")

    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # request = Net::HTTP::Post.new(url)
    # request["x-ibm-client-id"] = 'REPLACE_THIS_KEY'
    # request["authorization"] = 'REPLACE_THIS_VALUE'
    # request["rquid"] = 'REPLACE_THIS_VALUE'
    # request["content-type"] = 'application/x-www-form-urlencoded'
    # request["accept"] = 'application/json'
    # request.body = "grant_type=tonip&scope=ubacarai"

    # response = http.request(request)
    # puts response.read_body
    Rails.logger.info('---------------------------hi! welcome index!')
  end
end
