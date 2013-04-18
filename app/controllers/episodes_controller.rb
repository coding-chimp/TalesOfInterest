class EpisodesController < ApplicationController
	before_filter :search, except: [:index, :podcast_index]
	before_filter :authenticate_user!, except: [:index, :show, :latest]
	before_filter :standard_sidebar, only: [:index, :show, :podcast_index]

	def index
		ppp = Settings.first.posts_per_page
		@search = Episode.published.recent.search(params[:search])
		@episodes = @search.page(params[:page]).per(ppp)
		@podcasts = Podcast.order("name")
	end

	def podcast_index
		@podcast = Podcast.find(params[:podcast])
		@search = @podcast.episodes.recent.search(params[:search])
		@episodes = @search
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
		@podcast = Podcast.find(params[:podcast])
		@episode = Episode.new(params[:episode])

		if @episode.save
			if params[:publish]
				@episode.publish!
				redirect_to(podcast_episodes_path(@episode.podcast), notice: 'Episode was successfully published.')
			else
				redirect_to(podcast_episodes_path(@episode.podcast), notice: 'Episode was successfully created.')
			end
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
			if params[:publish]
				@episode.publish!
				redirect_to(podcast_episodes_path(@podcast), notice: 'Episode was successfully published.')
			else
				redirect_to(podcast_episodes_path(@podcast), notice: 'Episode was successfully updated.')
			end
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
		@episode = @podcast.episodes.published.recent.last
		redirect_to episode_url(@podcast, @episode)
	end
end