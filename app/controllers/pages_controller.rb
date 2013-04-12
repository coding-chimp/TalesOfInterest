class PagesController < ApplicationController
	before_filter :search, :only => [:index, :show, :new, :edit]

	def index
		@pages = Page.order("titel asc")
	end

	def show
		@page = Page.find(params[:id])
	end

	def new
		@page = Page.new
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

	private

	def search
		@search = Episode.search(params[:search])
		if params[:search]
			redirect_to :controller => :episodes, :action => :index, :search => params[:search]
		end
	end
end