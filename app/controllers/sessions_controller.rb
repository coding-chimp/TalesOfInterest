class SessionsController < Devise::SessionsController
	def new
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to controller: :episodes, action: :index, search: params[:search]
		end
	end
end