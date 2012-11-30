ActiveAdmin.register Page do

  config.clear_sidebar_sections! 
  
  index do
    column :titel
    default_actions
  end

  show do
#    attributes_table do
#      row :titel
#      row :content
#      row :created_at
#      row :updated_at
#    end
    h3 page.titel
    div do
      simple_format markdown(page.content)
    end
    div do
      simple_format("======") +
      pretty_format("Last updated at ") +
      pretty_format(page.updated_at)
    end
  end

  form do |f|
    f.inputs do
      f.input :titel
      f.input :content
    end

    f.buttons
  end
  sidebar :help, :only => :edit do
    simple_format "The content can be formatted in HTML Syntax or " + 
    link_to("Markdown", "http://daringfireball.net/projects/markdown/") + "."
  end

end
