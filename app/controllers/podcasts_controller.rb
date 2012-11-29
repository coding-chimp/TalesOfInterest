class PodcastsController < ApplicationController
	def show
		@podcast = Podcast.find(params[:id])
		@episodes = @podcast.episodes.order("created_at desc").page(params[:page]).per(5)
	end
end