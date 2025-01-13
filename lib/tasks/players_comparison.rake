# frozen_string_literal: true

namespace :players_comparison do
  desc "Create default players comparison data"
  task create_default: :environment do
    puts 'Creating default players comparison...'
    default_data = PlayersComparison.find_by(is_default_data: true)
    if default_data.present?
      puts 'Default players comparison already exists.'
      next
    end

    default_text = <<~TEXT
No.		Name	FideID	FED	RtgI	RtgN	Club/City
1	CM	Tran Thanh Tu	12401404	JPN	2372	2557	
2	IM	Nanjo Ryosuke	7000634	JPN	2310	2472	
3	FM	Yamada Kohei	7000936	JPN	2204	2278	
4	FM	Jones Stephen	2000970	USA	2202	2074	
5	CM	Averbukh Alex	2028255	JPN	2111	2281	
6		Matsumura Cocoro	36087114	JPN	2033	1883	
7		Nagataki Kota	7003544	JPN	2001	1971	
8		Yonemitsu Kohei	7005318	JPN	1998	1611	
9		Nguyen Tuan Anh	12432288	VIE	1987	1811	
10		Furuya Masahiro	7001606	JPN	1978	2003	
    TEXT

    PlayersComparison.create(input_text: default_text, is_default_data: true)

    puts 'Default players comparison created.'
  end
end
