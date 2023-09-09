# frozen_string_literal: true

module PlayersHelper
    def records_with_previous_month(records, previous_records)
        res = []
        records.each do |r|
            pre = nil
            previous_records.each do |p|
                if r.player_id == p.player_id
                    pre = p
                    break
                end
            end
            res.push [r, pre]
        end
        return res
    end
end
