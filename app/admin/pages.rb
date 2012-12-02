ActiveAdmin.register Page do

  config.clear_sidebar_sections! 
  
  index do
    column :titel
    default_actions
  end
  sidebar "Import", :only => :index do
    render "admin/import"
  end
  collection_action :import_xml, :method => :post do
    items = Nokogiri::XML(params[:import][:file]).xpath("//channel//item")
    items.each do |item|
      Page.create!( :titel => item.at_xpath("title").text,
                    :content => item.at_xpath("content:encoded").text )
    end
    redirect_to admin_pages_path, :notice => "Pages imported successfully!"
  end

  show do
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
  sidebar :help, :only => [:edit, :new] do
    simple_format "The content can be formatted in HTML Syntax or " + 
    link_to("Markdown", "http://daringfireball.net/projects/markdown/") + "."
  end

end
