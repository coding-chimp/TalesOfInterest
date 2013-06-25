class EpisodesController < ApplicationController
	before_filter :search, except: [:index, :podcast_index]
	before_filter :authenticate_user!, except: [:index, :show, :latest]
	before_filter :standard_sidebar, only: [:index, :show]

	def index
		ppp = Settings.first.posts_per_page
		@search = Episode.includes(:podcast).published.recent.search(params[:q])
		@episodes = @search.result(distinct: true).page(params[:page]).per(ppp)
		@podcasts = Podcast.order("name")

		respond_to do |format|
			format.html
			format.json { render json: EpisodesAnalyticsDatatable.new(view_context) }
		end
	end

	def podcast_index
		@podcast = Podcast.find(params[:podcast])
		@search = @podcast.episodes.recent.search(params[:q])
		@episodes = @search.result(distinct: true)
	end

	def show
		podcast = Podcast.find(params[:podcast])
		@episode = podcast.latest_episode
		if params[:id].to_i > @episode.number
			redirect_to episode_path(podcast, @episode), alert: "An episode with number #{params[:id]} is not available. This is the most recent episode."
		else
			@episode = podcast.episodes.find(params[:id])
		end
	end

	def new
		podcast = Podcast.find(params[:podcast])
		@episode = Episode.new
		@episode.podcast = podcast
		url = @episode.set_file_url
		audio_file = AudioFile.new(url: url, media_type: "mp4", episode_id: @episode.id)
		@episode.audio_files << audio_file
	end

	def create
		podcast = Podcast.find(params[:podcast])
		@episode = Episode.includes(:podcast, :show_notes).new(params[:episode])

		params[:episode][:draft] = false if params[:publish]

		if @episode.save
			if params[:save_close]
				redirect_to(podcast_episodes_path(podcast), notice: 'Episode was successfully saved.')
			else
				redirect_to(edit_episode_path(podcast, @episode), notice: 'Episode was successfully saved.')
			end
		else
			render action: "new"
		end
	end

	def edit
		podcast = Podcast.find(params[:podcast])
		@episode = podcast.episodes.find(params[:id])
	end

	def update
		podcast = Podcast.find(params[:podcast])
		@episode = podcast.episodes.find(params[:id])

		params[:episode][:draft] = false if params[:publish]

		if @episode.update_attributes(params[:episode])
			if params[:save_close]
				redirect_to(podcast_episodes_path(podcast), notice: 'Episode was successfully saved.')
			else
				redirect_to(edit_episode_path(podcast, @episode), notice: 'Episode was successfully saved.')
			end
		else
			render action: "edit"
		end
	end

	def destroy
		podcast = Podcast.find(params[:podcast])
		@episode = podcast.episodes.find(params[:id])
		@episode.destroy
		redirect_to podcast_episodes_path
	end

	def latest
		podcast = Podcast.find(params[:podcast])
		@episode = podcast.episodes.published.recent.first
		redirect_to episode_url(podcast, @episode)
	end
end