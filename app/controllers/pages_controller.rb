class PagesController < ApplicationController
	include ImportHelper
	before_filter :search
	before_filter :standard_sidebar, only: [:show]
	before_filter :authenticate_user!, except: [:show]

	def index
		@pages = Page.order("title asc")
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
			expire_fragment("pages")
			expire_fragment("footer_pages")
			redirect_to(pages_path, notice: 'Page was successfully created.')
		else
			render action: "new"
		end
	end

	def edit
		@page = Page.find(params[:id])
	end

	def update
		@page = Page.find(params[:id])

		if @page.update_attributes(params[:page])
			expire_fragment("pages")
			expire_fragment("footer_pages")
			redirect_to(pages_path, notice: 'Page was successfully updated.')
		else
			render action: "edit"
		end
	end

	def destroy
		@page = Page.find(params[:id])
		@slug = FriendlyId::Slug.find_by_slug(@page.slug)
		@slug.destroy
		@page.destroy
		expire_fragment("pages")
		expire_fragment("footer_pages")
		redirect_to pages_path
	end

	def import_xml
		if params[:import] == nil
			flash[:error] = "Choose a xml file."
			render 'import_form'
		else
			import_pages(params[:import][:file])
    	redirect_to pages_path, notice: "Pages imported successfully!"
    end
	end
end