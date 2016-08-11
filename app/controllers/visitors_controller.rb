class VisitorsController < ApplicationController
  before_action :set_charts
  
  def set_charts
    @charts = ['line', 'bar', 'pie', 'zipf']
  end
  
end
