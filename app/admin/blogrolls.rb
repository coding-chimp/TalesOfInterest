ActiveAdmin.register Blogroll, :as => "Blog" do

  config.clear_sidebar_sections!
  
  index do
    column :name
    column :url
    column :description

    default_actions
  end
  sidebar :help, :only => :index do
    simple_format "Create links for your Blogroll."
  end

  show do
    attributes_table do
      row :name
      row :url
      row :description
    end
  end

end
