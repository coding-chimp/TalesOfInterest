class EpisodesController < ApplicationController
	def index
		@episodes = Episode.order("created_at desc")
	end

	def show
		@episode = Episode.find(params[:id])
	end
end