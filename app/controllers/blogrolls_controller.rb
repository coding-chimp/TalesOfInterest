class BlogrollsController < ApplicationController
	before_filter :search
	before_filter :authenticate_user!

	def index
		@blogroll = Blogroll.order("name asc")
	end

	def new
		@item = Blogroll.new
	end

	def create
		@item = Blogroll.new(params[:blogroll])

		if @item.save
			redirect_to(blogrolls_path, notice: 'Blogroll item was successfully created.')
		else
			render action: "new"
		end
	end

	def edit
		@item = Blogroll.find(params[:id])
	end

	def update
		@item = Blogroll.find(params[:id])

		if @item.update_attributes(params[:blogroll])
			redirect_to(blogrolls_path, notice: 'Blogroll item was successfully updated.')
		else
			render action: "edit"
		end
	end

	def destroy
		@item = Blogroll.find(params[:id])
		@item.destroy
		redirect_to blogrolls_path
	end

	private

	def search
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to controller: :episodes, action: :index, search: params[:search]
		end
	end
end