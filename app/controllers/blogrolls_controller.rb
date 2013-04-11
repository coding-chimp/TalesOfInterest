class BlogrollsController < ApplicationController
	def index
		@blogroll = Blogroll.order("name asc")
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def new
		@item = Blogroll.new
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def create
		@item = Blogroll.new(params[:blogroll])

		if @item.save
			redirect_to(blogrolls_path, :notice => 'Blogroll item was successfully created.')
		else
			render :action => "new"
		end
	end

	def edit
		@item = Blogroll.find(params[:id])
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def update
		@item = Blogroll.find(params[:id])

		if @item.update_attributes(params[:blogroll])
			redirect_to(blogrolls_path, :notice => 'Blogroll item was successfully updated.')
		else
			render :action => "edit"
		end
	end

	def destroy
		@item = Blogroll.find(params[:id])
		@item.destroy
		redirect_to blogrolls_path
	end
end