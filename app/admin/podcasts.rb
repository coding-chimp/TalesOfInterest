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
  sidebar "Import", :only => :index do
    render "admin/import"
  end
  collection_action :import_xml, :method => :post do
    items = Nokogiri::XML(params[:import][:file]).xpath("//channel//item")
    items.each do |item|
      unless item.at_xpath("title").text.scan(/(.+) \d+/)[0] == nil
        if Podcast.find_by_name(item.at_xpath("title").text.scan(/(.+) \d+/)[0][0]) == nil
          Podcast.create!(:name => item.at_xpath("title").text.scan(/(.+) \d+/)[0][0])
        end
        Episode.create!(:podcast => Podcast.find_by_name(item.at_xpath("title").text.scan(/(.+) \d+/)[0][0]),
                        :number => item.at_xpath("title").text.scan(/\d+/)[0].to_i,
                        :title => item.at_xpath("title").text.scan(/:\D(.+)/)[0][0],
                        :description => item.at_xpath("content:encoded").text,
                        :created_at => item.at_xpath("pubDate").text  )
      end
    end
    redirect_to admin_podcasts_path, :notice => "Episodes imported successfully!"
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