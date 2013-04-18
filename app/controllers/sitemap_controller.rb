class SitemapController < ApplicationController
	def index
		@episodes = Episode.published.all(select: "title, id, podcast_id, updated_at, slug", order: "published_at desc", limit: 50000)

		respond_to do |format|
			format.xml { render layout: false }
		end
	end
end