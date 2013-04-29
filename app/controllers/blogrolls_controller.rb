class BlogrollsController < ApplicationController
	before_filter :search, :authenticate_user!

	def index
		@blogroll = Blogroll.order("name asc")
	end

	def new
		@item = Blogroll.new
	end

	def create
		@item = Blogroll.new(params[:blogroll])

		if @item.save
			expire_fragment("blogroll")
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
			expire_fragment("blogroll")
			redirect_to(blogrolls_path, notice: 'Blogroll item was successfully updated.')
		else
			render action: "edit"
		end
	end

	def destroy
		@item = Blogroll.find(params[:id])
		@item.destroy
		expire_fragment("blogroll")
		redirect_to blogrolls_path
	end
end