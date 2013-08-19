class DashboardController < ApplicationController
  before_filter :search, :authenticate_user!

  def index
    @settings = Settings.first
    @podcasts = Podcast.order("name")
    @commits = Grit::Repo.new(Rails.root + '.git').commits
  end

end
