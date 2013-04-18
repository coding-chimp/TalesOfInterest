class SettingsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :search

	def edit
		@settings = Settings.first
	end

	def update
		@settings = Settings.first

		if @settings.update_attributes(params[:settings])
			redirect_to(settings_path, notice: 'Settings were successfully updated.')
		else
			render action: :edit
		end
	end

	private

	def search
		@search = Episode.published.recent.search(params[:search])
		if params[:search]
			redirect_to controller: :episodes, action: :index, search: params[:search]
		end
	end
end
