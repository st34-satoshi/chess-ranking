class HomeController < ApplicationController

  def distribution
    @distribution_graph_parameter = distribution_graph_params
    @date1 = @distribution_graph_parameter.month_1
    records1 = Record.year_is(@date1.year).month_is(@date1.month)
    @ratings1 = records1.map{ |r| r.standard_rating}
    @date2 = @distribution_graph_parameter.month_2
    records2 = Record.year_is(@date2.year).month_is(@date2.month)
    @ratings2 = records2.map{ |r| r.standard_rating}
  end

  private

  def distribution_graph_params
    DistributionGraphParameter.new(params.fetch(:distribution_graph_parameter, {}))
  end
end
