class EpisodesController < ApplicationController
	def index
		@episodes = Episode.order("created_at desc").page(params[:page]).per(5)
		@podcasts = Podcast.order("name")
	end

	def show
		@episode = Episode.find(params[:id])
	end
end