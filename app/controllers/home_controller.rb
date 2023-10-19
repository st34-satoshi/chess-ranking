class HomeController < ApplicationController

  def distribution
    @date1 = Time.zone.now.last_month # TODO: set using param
    records1 = Record.year_is(@date1.year).month_is(@date1.month)
    @ratings1 = records1.map{ |r| r.standard_rating}
    @date2 = Time.zone.now.ago(1.year)
    records2 = Record.year_is(@date2.year).month_is(@date2.month)
    @ratings2 = records2.map{ |r| r.standard_rating}
  end
end
