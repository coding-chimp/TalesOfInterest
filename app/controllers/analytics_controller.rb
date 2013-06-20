class AnalyticsController < ApplicationController
  before_filter :search, :authenticate_user!

  def index
    @episodes = Episode.all
  end
end