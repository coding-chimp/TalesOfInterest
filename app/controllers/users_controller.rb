class UsersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :search

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])

		if @user.save
			redirect_to(users_path, notice: 'User was successfully created.')
		else
			render action: :new
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		if params[:user][:password].blank?
			params[:user].delete(:password)
			params[:user].delete(:password_confirmation)
		end

		@user = User.find(params[:id])

		if @user.update_attributes(params[:user])
			sign_in(@user, bypass: true)
			redirect_to(users_path, notice: 'User was successfully updated.')
		else
			render action: :edit
		end
	end

	def destroy
		@current_user = current_user
		@user = User.find(params[:id])
		@user.destroy
		sign_in(@current_user, bypass: true)
		redirect_to users_path
	end

	private

	def search
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to controller: :episodes, action: :index, search: params[:search]
		end
	end

end
