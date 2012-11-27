ActiveAdmin.register Podcast do

  config.clear_sidebar_sections!

  index do
    column :name
    column :description
    column do |podcast|
      link_to "Episodes", admin_podcast_episodes_path(podcast)
    end 
    default_actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end

    f.buttons
  end
end