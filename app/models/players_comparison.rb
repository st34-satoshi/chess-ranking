class PlayersComparison < ApplicationRecord
  generate_public_uid
  serialize :players_list, Array
  attr_accessor :contain_result_url
  validate :result_url_valid?
  before_save :clean_result_url
  before_save :input_to_list

  def to_param
    public_uid
  end

  def open_url_tab?
    contain_result_url == 'true' || result_url.present?
  end

  private

  def clean_result_url
    self.result_url = result_url&.strip
    self.result_url = result_url&.split('?')&.first
  end

  def input_to_list
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
      fields = line.split(/,|\t/).map(&:strip)
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
  end

  def fetch_table_from_url
    response = URI.open(result_url)
    html = Nokogiri::HTML(response)
    table = html.css('table.CRs1').first
    
    if table.nil?
      errors.add(:result_url, :invalid)
      throw(:abort)
      return
    end

    rows = table.css('tr')
    header = rows.shift.css('td,th').map(&:text).map(&:strip)
    name_index = header.index { |col| col.downcase.include?('name') }
    
    if name_index.blank?
      errors.add(:result_url, :name_column_missing) 
      throw(:abort)
      return
    end

    self.players_list = rows.map do |row|
      fields = row.css('td').map(&:text).map(&:strip)
      fields[name_index] if fields[name_index].present?
    end.compact
  end
end
