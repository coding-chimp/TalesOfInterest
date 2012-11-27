ActiveAdmin.register Page do

  config.clear_sidebar_sections! 
  
  index do
    column :titel

    default_actions
  end

  show do
    attributes_table do
      row :titel
      row :content
      row :created_at
      row :updated_at
    end
  end

end
