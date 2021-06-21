# frozen_string_literal: true
require 'uri'
require 'openssl'
require 'net/http'

class SessionsController < ApplicationController
  def create
    Rails.logger.info(request.env['omniauth.auth']) if request.env['omniauth.auth']
    Rails.logger.info('====================================Everithing is OK! ========================================')
    redirect_to '/'
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def sendiboba(params={})
    puts response.read_body
  end
end
