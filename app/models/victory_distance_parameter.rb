# frozen_string_literal: true

class VictoryDistanceParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :player1, :string, default: 'Nanjo Ryosuke'
  attribute :player2, :string

  attribute :start
  attribute :goal

  attribute :path1, default: [] # [0]は[1]に勝っている, [player2, ..., player1] or nil
  attribute :path2, default: []

  def initialize(params)
    super(params.permit(:player1, :player2))
  end

  def calculate_path
    # 1が2に勝つ道をさがす
    # 2から始めて勝ったプレーヤーのリストを作る
    # 1が現れたら1が勝った人の中から最後のリストにある人をさがす、2まで続ける
    # プレーヤーはランダムで選ぶ
    # 計算時間を制限するために6回で止める
    self.start = Player.find_by(name_en: player1)
    self.goal = Player.find_by(name_en: player2)
    if start.nil? || goal.nil?
      self.path1 = nil
      self.path2 = nil
      return
    end
    self.path1 = find_loser([goal.id], [], start, 1)
    self.path2 = find_loser([start.id], [], goal, 1)
  end

  def find_loser(player_ids, appeard_ids, start, ind)
    # return path from goal [start, ..., goal]
    return nil if ind > 6

    losers = Match.where(lost_id: player_ids).pluck(:won_id).uniq - appeard_ids
    return nil if losers.empty?

    if losers.include?(start.id)
      # losersから一人選んで追加する
      select_player_id = Match.where(lost_id: player_ids).where(won_id: start.id).pluck(:lost_id).sample
      return [start, Player.find(select_player_id)]
    end

    appeard_ids = (player_ids + appeard_ids).uniq

    path = find_loser(losers, appeard_ids, start, ind + 1)
    return nil if path.nil?

    # player_idsからpathの最初のプレーヤーが勝ったプレーヤーをランダムに選択してpathに加える
    select_player_id = Match.where(lost_id: player_ids).where(won_id: path.last.id).pluck(:lost_id).sample
    path + [Player.find(select_player_id)]
  end
end
