# frozen_string_literal: true

require 'omniauth/sberbank/version'
require 'omniauth'

# :nodoc:
module OmniAuth
  # :nodoc:
  module Strategies
    autoload :Sberbank, 'omniauth/strategies/sberbank'
  end
end

OmniAuth.config.add_camelization 'sberbank', 'Sberbank'
