module ApplicationHelper
	def markdown(text)
 		Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), :space_after_headers => true, :autolink => true).render(text).html_safe
	end
end
