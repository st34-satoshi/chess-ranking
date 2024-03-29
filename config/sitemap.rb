# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://chess-ranking.stu345.com'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  add players_path, priority: 0.8, changefreq: 'daily'
  add '/players?locale=ja', priority: 0.7, changefreq: 'daily'

  Player.find_each do |player|
    add player_path(player), lastmod: player.updated_at
  end
end
