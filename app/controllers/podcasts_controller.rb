class PodcastsController < ApplicationController
	before_filter :search, :only => [:index, :show, :new, :edit]

	def index
		@podcasts = Podcast.order("name asc")
	end

	def show
		@podcast = Podcast.find(params[:id])
		@episodes = @podcast.episodes.order("created_at desc").page(params[:page]).per(5)
	end

	def new
		@podcast = Podcast.new
	end

	def create
		@podcast = Podcast.new(params[:podcast])

		if @podcast.save
			redirect_to(podcasts_path, :notice => 'Podcast was successfully created.')
		else
			render :action => "new"
		end
	end

	def edit
		@podcast = Podcast.find(params[:id])
	end

	def update
		@podcast = Podcast.find(params[:id])

		if @podcast.update_attributes(params[:podcast])
			redirect_to(podcasts_path, :notice => 'Podcast was successfully updated.')
		else
			render :action => "edit"
		end
	end

	def destroy
		@podcast = Podcast.find(params[:id])
		@podcast.destroy
		redirect_to podcasts_path
	end

	def feed
		@podcast = Podcast.find(params[:id])
		@episodes = @podcast.episodes.order("created_at desc")
	end

	private

	def search
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end
end