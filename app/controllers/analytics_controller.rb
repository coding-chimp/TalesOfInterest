class AnalyticsController < ApplicationController
  before_filter :search, :authenticate_user!

  def index
    @episode = Episode.includes(:podcast)
    if params[:episode].present?
      @episode = @episode.find_by_title(params[:episode])
    else
      @episode = @episode.order('downloads DESC').first
    end
  end
end