class EpisodesController < ApplicationController
	before_filter :search, only: [:edit, :show, :new]
	before_filter :authenticate_user!, except: [:index, :show, :latest]

	def index
		ppp = Settings.first.posts_per_page
		@search = Episode.search(params[:search])
		@episodes = @search.order("created_at desc").page(params[:page]).per(ppp)
		@podcasts = Podcast.order("name")
	end

	def podcast_index
		@podcast = Podcast.find(params[:podcast])
		@search = @podcast.episodes.search(params[:search])
		@episodes = @search.order("created_at desc")
	end

	def show
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.find(params[:id])
		session[:last_page] = request.env['HTTP_REFERER'] || podcast_path(@episode.podcast)
	end

	def new
		@podcast = Podcast.find(params[:podcast])
		@episode = Episode.new
		@episode.podcast = @podcast
	end

	def create
		@episode = Episode.new(params[:episode])

		if @episode.save
			redirect_to(podcast_episodes_path(@episode.podcast), :notice => 'Episode was successfully created.')
		else
			render :action => "new"
		end
	end

	def edit
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.find(params[:id])
	end

	def update
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.find(params[:id])

		if @episode.update_attributes(params[:episode])
			redirect_to(podcast_episodes_path(@podcast), :notice => 'Episode was successfully updated.')
		else
			render :action => "edit"
		end
	end

	def destroy
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.find(params[:id])
		@episode.destroy
		redirect_to podcast_episodes_path
	end

	def latest
		@podcast = Podcast.find(params[:podcast])
		@episode = @podcast.episodes.last
		redirect_to episode_url(@podcast, @episode)
	end

	private

	def search
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end
end