class AnalyticsController < ApplicationController
  before_filter :search, :authenticate_user!

  def index
    @episodes = Episode.order('downloads DESC')
    @episode = Episode.find_by_title(params[:episode]) || Episode.order('downloads DESC').first
  end
end