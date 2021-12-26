class Player < ApplicationRecord
    scope :name_en_has, ->(name) { where("name_en like ?", "%#{name}%") }
    scope :name_jp_has, ->(name) { where("name_jp like ?", "%#{name}%") }
    scope :ordered, -> { order(rating_standard: "DESC") }

    def self.players_name_has(name)
        Player.all.name_en_has(name).or(Player.all.name_jp_has(name))
    end
end
