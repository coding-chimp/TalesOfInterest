ActiveAdmin.register Podcast do

  config.clear_sidebar_sections!

  index do
    column "Artwork" do |podcast|
      image_tag(podcast.artwork, :height => '100')
    end
    column :name
    column :description
    column "# Episodes" do |podcast|
      podcast.episodes.count
    end
    column "Episodes" do |podcast|
      link_to("Episodes", admin_podcast_episodes_path(podcast), :class => "member_link") +
      link_to("New Episode", new_admin_podcast_episode_path(podcast), :class => "member_link")
    end
    default_actions
  end

  show do |podcast|
    panel "Episodes" do
      table_for podcast.episodes.order("number desc") do
        column :number
        column :title
        column :created_at
        column do |episode|
          link_to("View", admin_podcast_episode_path(podcast, episode), :class => "member_link") +
          link_to("Edit", edit_admin_podcast_episode_path(podcast, episode), :class => "member_link")
        end
      end
    end
  end
  sidebar "Podcast Information", :only => :show do
    attributes_table_for podcast do
      row "Artwork" do |podcast|
        image_tag(podcast.artwork, :height => '150')
      end
      row :name
      row :description
    end
    link_to("New Episode", new_admin_podcast_episode_path(podcast), :class => "member_link")
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