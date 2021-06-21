class WelcomeController < ApplicationController
  def index
    Rails.logger.info('---------------------------hi! welcome index!')
  end
end
