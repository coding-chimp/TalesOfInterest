ActiveAdmin.register Episode do
  belongs_to :podcast
	
  filter :number
  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :number, :input_html => { :value => episode.set_episode_number }
      f.input :title
      f.input :description
      f.input :playtime
      f.input :created_at, :as => :datepicker
    end

    f.has_many :chapters do |c|
      c.inputs "Chapter" do
        c.input :pretty_time, :label => "Timestamp"
        c.input :title
        if c.object.id
          c.input :_destroy, :as => :boolean, :label => "delete"
        end
        c.form_buffers.last
      end
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
  sidebar :help, :only => [:edit, :new] do
    simple_format(markdown("The description can be formatted in HTML Syntax or [Markdown](http://daringfireball.net/projects/markdown/).")) + 
    simple_format(markdown("If you leave **created_at** empty, it will be filled automatically.")) +
    simple_format(markdown("Fill the chapter **timestamp** with: **hh:mm:ss**."))
  end

  index do
    column :number
    column :title
    column :created_at
 
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
    panel "Chapters" do
      table_for ep.chapters do
        column "Timestamp", :pretty_time
        column :title
      end
    end
    panel "Show Notes" do
      table_for ep.show_notes do
        column :name
        column :url
      end
    end
  end

end