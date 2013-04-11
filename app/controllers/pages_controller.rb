class PagesController < ApplicationController
	def index
		@pages = Page.order("titel asc")
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def show
		@page = Page.find(params[:id])
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def new
		@page = Page.new
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def create
		@page = Page.new(params[:page])

		if @page.save
			redirect_to(pages_path, :notice => 'Page was successfully created.')
		else
			render :action => "new"
		end
	end

	def edit
		@page = Page.find(params[:id])
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end

	def update
		@page = Page.find(params[:id])

		if @page.update_attributes(params[:page])
			redirect_to(pages_path, :notice => 'Page was successfully updated.')
		else
			render :action => "edit"
		end
	end

	def destroy
		@page = Page.find(params[:id])
		@page.destroy
		redirect_to pages_path
	end
end