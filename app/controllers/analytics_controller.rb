class AnalyticsController < ApplicationController
  before_filter :search, :authenticate_user!

  def index
    @start = params[:start] || 4.weeks.ago
    @stop = params[:stop] || Date.today
    @start = @start.to_date
    @stop = @stop.to_date
    @episode = Episode.includes(:podcast)
    if params[:episode].present?
      @episode = @episode.find_by_title(params[:episode])
    else
      @episode = @episode.order('downloads DESC').first
    end
  end
end