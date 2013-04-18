class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def standard_sidebar
  	@sidebar = 'layouts/standard_sidebar'
  end

  def custom_sidebar
  	@sidebar = 'layouts/custom_sidebar'
  end
end
