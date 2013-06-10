class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    #dashboard_path
    podcasts_path
  end

  protected

  def search
		@search = Episode.published.recent.search(params[:q])
		if params[:q]
			redirect_to controller: :episodes, action: :index, q: params[:q]
		end
	end

  def standard_sidebar
  	@sidebar = 'layouts/standard_sidebar'
  end

  def custom_sidebar
  	@sidebar = 'layouts/custom_sidebar'
  end
end
