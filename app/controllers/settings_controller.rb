class SettingsController < ApplicationController
	before_filter :authenticate_user!, :search

	def edit
		@settings = Settings.first
	end

	def update
		@settings = Settings.first

		if @settings.update_attributes(params[:settings])
			expire_fragment("settings")
			redirect_to(settings_path, notice: 'Settings were successfully updated.')
		else
			render action: :edit
		end
	end
end
