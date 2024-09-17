# frozen_string_literal: true

namespace :add_rank do
  desc "Add standard_rank to records where it's null"
  task update_null_ranks: :environment do
    puts 'Updating records with null standard_rank...'

    10.times do
      record = Record.find_by(standard_rank: nil)

      if record.nil?
        puts 'No records found with null standard_rank.'
        break
      else
        puts "date is #{record.month}"
        Record.add_rank(record.month)
      end
    end

    puts 'Task completed.'
  end
end
