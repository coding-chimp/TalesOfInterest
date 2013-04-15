class SitemapController < ApplicationController
	def index
		@episodes = Episode.all(select: "title, id, podcast_id, updated_at, slug", order: "updated_at desc", limit: 50000)

		respond_to do |format|
			format.xml { render layout: false }
		end
	end
end