ActiveAdmin.register Episode do
  belongs_to :podcast
	
  filter :number
  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :playtime
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
    column :number
    column :title
    column :playtime
    column :created_at
    column :updated_at
 
    default_actions
  end

  show do |ep|
    attributes_table do
      row :number
      row :title
      row :description
      row :playtime
      row :file do
        ep.file.url
      end
      row :created_at
      row :updated_at
    end
  end

end