class HomeController < ApplicationController

  def distribution
    date = Time.zone.now.last_month # TODO: set using param
    records = Record.year_is(date.year).month_is(date.month)
    @ratings = records.map{ |r| r.standard_rating}
  end
end
