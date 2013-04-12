module ApplicationHelper
	def markdown(text)
 		Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), :space_after_headers => true, :autolink => true).render(text).html_safe
	end

	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + "_fields", f: builder, :collection => @id = id)			
		end
		link_to(name, '#', id: "add_fields", class: 'btn btn-info', data: {id: id, fields: fields.gsub("\n", "")})
	end
end
