ActiveAdmin.register AdminUser do

  config.clear_sidebar_sections! 
  
  index do
    column :email
    column :last_sign_in_at
    column :last_sign_in_ip

    default_actions
  end

  show do
    attributes_table do
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
end
