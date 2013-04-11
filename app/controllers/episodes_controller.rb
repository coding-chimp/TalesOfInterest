class EpisodesController < ApplicationController
	def index
		@search = Episode.search(params[:search])
		@episodes = @search.order("created_at desc").page(params[:page]).per(5)
		@podcasts = Podcast.order("name")
	end

	def show
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.find(params[:id])
		session[:last_page] = request.env['HTTP_REFERER'] || podcast_path(@episode.podcast)
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def latest
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.last
		redirect_to episode_url(@podcast, @episode)
	end
end