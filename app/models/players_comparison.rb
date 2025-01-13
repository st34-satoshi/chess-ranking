class PlayersComparison < ApplicationRecord
  generate_public_uid
  serialize :players_list, Array
  attr_accessor :contain_result_url
  validate :result_url_valid?
  before_save :clean_result_url
  before_save :result_url_to_players_list
  before_save :input_to_list
  before_save :sanitize_players_list

  def to_param
    public_uid
  end

  def open_url_tab?
    contain_result_url == 'true' || result_url.present?
  end

  def dates
    first_record = Record.order(:month).first
    return [] unless first_record

    date_array = []
    current_month = first_record.month
    today = Date.today.beginning_of_month
    
    while current_month <= today
      date_array.push(current_month.strftime('%Y-%m'))
      current_month = current_month.next_month
    end
    date_array
  end

  def players_records
    # return example
    # [
    #   { name: 'Player 1', ratings: {'2020-01': 2500, '2020-02': 2600, '2020-03': 2700} },
    #   { name: 'Player 2', ratings: {'2020-01': 2400, '2020-02': 2500, '2020-03': 2600} },
    #   { name: 'Player 3', ratings: {'2020-01': 2300, '2020-03': 2500} }
    # ].to_json
    players = []
    players_list.each do |player_name|
      player = Player.find_by(name_en: player_name)
      next unless player
      player_records = player.records.order(:month).map { |record| [record.month.strftime('%Y-%m'), record.standard_rating] }.to_h
      players.push({ name: player_name, ratings: player_records })
    end
    players.to_json
  end

  private

  def clean_result_url
    self.result_url = result_url&.strip
    self.result_url = result_url&.split('?')&.first
  end

  def input_to_list
    return if contain_result_url == 'true'
    if input_text.blank?
      errors.add(:input_text, :blank)
      throw(:abort)
      return
    end
    
    lines = input_text.split("\n")
    header = lines.shift.split(/,|\t/).map(&:strip) # Split and store header
    name_index = header.index { |col| col.downcase.include?('name') }
    if name_index.blank?
      errors.add(:input_text, :name_column_missing)
      throw(:abort)
      return
    end
    self.players_list = lines.map do |line|
      next if line.strip.empty?
      fields = line.split("\t").map(&:strip)
      fields[name_index] if fields[name_index].present? # Only store name
    end.compact
  end

  def result_url_valid?
    if contain_result_url == 'true' && result_url.blank?
      errors.add(:result_url, :blank)
      return false
    end
    return true if result_url.blank?
    if result_url.present? && result_url.start_with?('https://chess-results.com/tnr')
      true
    else
      errors.add(:result_url, :invalid)
      false
    end
  end

  def result_url_to_players_list
    return if contain_result_url != 'true'

    require 'open-uri'
    response = URI.open(result_url)
    html = Nokogiri::HTML(response)
    table = html.css('table.CRs1').first
    
    if table.nil?
      errors.add(:result_url, :failed_to_get_players)
      throw(:abort)
      return
    end

    rows = table.css('tr')
    header = rows.shift.css('td,th').map(&:text).map(&:strip)
    name_index = header.index { |col| col.downcase.include?('name') }
    
    if name_index.blank?
      errors.add(:result_url, :failed_to_get_players) 
      throw(:abort)
      return
    end

    self.players_list = rows.map do |row|
      fields = row.css('td').map(&:text).map(&:strip)
      fields[name_index] if fields[name_index].present?
    end.compact
  end

  def sanitize_players_list
    self.players_list = players_list&.map { |name| name&.gsub(',', '') }
  end
end
