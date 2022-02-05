# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.

# Example:
#
# set :output, "/path/to/my/cron_log.log"

every 1.day, at: '5:00 am' do
  rake '-s sitemap:refresh'
end
