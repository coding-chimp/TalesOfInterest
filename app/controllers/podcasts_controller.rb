class PodcastsController < ApplicationController
	include ImportHelper
	before_filter :search
	before_filter :authenticate_user!, except: [:show, :feed]
	before_filter :standard_sidebar, only: [:show]

	def index
		@podcasts = Podcast.order("name asc")
	end

	def show
		ppp = Settings.first.posts_per_page
		@podcast = Podcast.find(params[:id])
		@episodes = @podcast.episodes.includes(:podcast).published.recent.page(params[:page]).per(ppp)
	end

	def new
		@podcast = Podcast.new
	end

	def create
		@podcast = Podcast.new(params[:podcast])

		if @podcast.save
			expire_fragment("nav-podcasts")
			expire_fragment("mobile-podcasts")
			expire_fragment("subscribe-podcasts")
			expire_fragment("mobile-subscribe-podcasts")
			redirect_to(podcasts_path, notice: 'Podcast was successfully created.')
		else
			render action: "new"
		end
	end

	def edit
		@podcast = Podcast.find(params[:id])
	end

	def update
		@podcast = Podcast.find(params[:id])

		if @podcast.update_attributes(params[:podcast])
			expire_fragment("nav-podcasts")
			expire_fragment("mobile-podcasts")
			expire_fragment("subscribe-podcasts")
			expire_fragment("mobile-subscribe-podcasts")
			redirect_to(podcasts_path, notice: 'Podcast was successfully updated.')
		else
			render action: "edit"
		end
	end

	def destroy
		@podcast = Podcast.find(params[:id])
		@slug = FriendlyId::Slug.find_by_slug(@podcast.slug)
		@slug.destroy
		@podcast.destroy
		expire_fragment("nav-podcasts")
		expire_fragment("mobile-podcasts")
		expire_fragment("subscribe-podcasts")
		expire_fragment("mobile-subscribe-podcasts")
		redirect_to podcasts_path
	end

	def import_xml
		if params[:import] == nil
			flash[:error] = "Choose a xml file."
			render 'import_form'
		else
			import_episodes(params[:import][:file])
    	redirect_to podcasts_path, notice: "Episodes imported successfully!"
    end
	end

	def feed
		@settings = Settings.first
		@podcast = Podcast.find(params[:id])
		@episodes = @podcast.episodes.published.recent
	end
end