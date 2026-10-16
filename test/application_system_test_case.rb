# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV['SELENIUM_REMOTE_URL']
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 3001
    Capybara.app_host = "http://#{ENV.fetch('CAPYBARA_APP_HOST', 'web')}:#{Capybara.server_port}"
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400],
                         options: { browser: :remote, url: ENV.fetch('SELENIUM_REMOTE_URL') }
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end
end
