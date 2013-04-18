class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def search
		@search = Episode.published.recent.search(params[:search])
		if params[:search]
			redirect_to controller: :episodes, action: :index, search: params[:search]
		end
	end

  def standard_sidebar
  	@sidebar = 'layouts/standard_sidebar'
  end

  def custom_sidebar
  	@sidebar = 'layouts/custom_sidebar'
  end
end
