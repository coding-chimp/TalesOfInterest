ActiveAdmin.register Episode do
  belongs_to :podcast
	
	filter :podcast
  filter :number
  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :number
      f.input :title
      f.input :description
      f.input :length
      f.input :episode_url
      f.input :created_at, :as => :datepicker
      f.input :slug
    end

    f.has_many :show_notes do |n|
    	n.inputs "Show Note" do
    		n.input :name
    		n.input :url
        if n.object.id
          n.input :_destroy, :as => :boolean, :label => "delete"
        end
        n.form_buffers.last
    	end
    end

    f.buttons
  end

  index do
    column :podcast
    column :number
    column :title
    column :length
    column :created_at
    column :updated_at
 
    default_actions
  end

  show do
    attributes_table do
      row :podcast
      row :number
      row :title
      row :description
      row :length
      row :episode_url
      row :created_at
      row :updated_at
    end
  end

end