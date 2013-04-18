class SessionsController < Devise::SessionsController
	before_filter :standard_sidebar

	def new
		@search = Episode.published.recent.search(params[:search])
		if params[:search]
			redirect_to controller: :episodes, action: :index, search: params[:search]
		end
	end
end