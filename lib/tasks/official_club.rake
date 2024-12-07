# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'json'

namespace :official_club do
  desc 'Scrape official chess clubs and output as JSON'
  task scrape: :environment do
    # NCS official club page URL
    url = 'https://japanchess.org/clublist/'

    begin
      # Get the page content
      response = HTTParty.get(url)
      doc = Nokogiri::HTML(response.body)

      clubs = []

      # binding.pry
      region = nil
      doc.css('.entry-content > *').each do |content|
        if content.name == 'h2'
          location = content.text.strip
        elsif content.name == 'table'
          header_row = content.at_css('tr')
          header_link = header_row.at_css('a')
          if header_link
            site_url = header_link['href']
            name = header_link.text.strip
            puts "Name: #{name}, URL: #{site_url}"
          end

          representative_row = content.css('tr')[1]
          if representative_row
            representative_name = representative_row.css('td')[1]&.text&.strip
            puts "Representative Name: #{representative_name}"
          end

          email_row = content.css('tr')[2]
          if email_row
            email = email_row.css('td')[1]&.text&.strip
            puts "Email: #{email}"
          end

          club = Club.new(name: name, site_url: site_url, representative_name: representative_name, email: email, location: location, is_official: true)
          clubs << club
        end
      end

      # Write to JSON file
      File.write('lib/data/official_clubs.json', clubs.to_json)

      puts "Successfully scraped #{clubs.count} clubs and saved to lib/data/official_clubs.json"
    rescue StandardError => e
      puts "Error occurred while scraping: #{e.message}"
    end
  end
end
