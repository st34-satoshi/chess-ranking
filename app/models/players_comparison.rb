class PlayersComparison < ApplicationRecord
  generate_public_uid
  serialize :players_list, Array
  before_save :clean_result_url
  before_save :input_to_list

  def to_param
    public_uid
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
end
