ActiveAdmin.register Podcast do

  config.clear_sidebar_sections!

  index do
    column :name
    column :description
    column "Artwork" do |podcast|
      image_tag(podcast.artwork, :height => '100')
    end
    column do |podcast|
      link_to "Episodes", admin_podcast_episodes_path(podcast)
    end
    column do |podcast|
      link_to "New Episode", new_admin_podcast_episode_path(podcast)
    end
    default_actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row "Artwork" do |podcast|
        image_tag(podcast.artwork, :height => '100')
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :artwork
    end

    f.buttons
  end
end