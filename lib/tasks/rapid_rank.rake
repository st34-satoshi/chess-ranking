# frozen_string_literal: true

namespace :rapid_rank do
  desc 'Recalculate rapid ranks for all months or a specified month (YYYY-MM)'
  task :recalculate, [:month] => :environment do |_task, args|
    months = if args[:month]
               raise ArgumentError, 'month must be YYYY-MM' unless /\A\d{4}-\d{2}\z/.match?(args[:month])

               [Date.strptime(args[:month], '%Y-%m')]
             else
               Record.distinct.pluck(:month).map(&:beginning_of_month).uniq.sort
             end

    months.each do |month|
      count = Record.add_rapid_rank(month)
      puts "#{month.strftime('%Y-%m')}: processed #{count} records"
    end
  end
end
