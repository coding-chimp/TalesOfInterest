ActiveAdmin.register Blogroll, :as => "Blog" do

  config.clear_sidebar_sections! 
  
  index do
    column :name
    column :url

    default_actions
  end

  show do
    attributes_table do
      row :name
      row :url
      row :created_at
      row :updated_at
    end
  end

end
