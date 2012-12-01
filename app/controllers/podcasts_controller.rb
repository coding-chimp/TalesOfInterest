class PodcastsController < ApplicationController
	def show
		@podcast = Podcast.find(params[:id])
		@episodes = @podcast.episodes.order("created_at desc").page(params[:page]).per(5)
		@search = @podcast.episodes.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end
end