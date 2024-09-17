# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :won, class_name: 'Player'
  belongs_to :lost, class_name: 'Player'
end
