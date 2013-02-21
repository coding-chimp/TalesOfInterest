ActiveAdmin.register Podcast do

  config.clear_sidebar_sections!

  index do
    column "Artwork" do |podcast|
      image_tag(podcast.artwork, :height => '100')
    end
    column :name
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
    simple_format("Import episodes from a XML file.") + 
    render("admin/import")
  end
  collection_action :import_xml, :method => :post do
    items = Nokogiri::XML(params[:import][:file]).xpath("//channel//item")
    items.each do |item|
      unless item.at_xpath("title").text.scan(/(.+) \d+/)[0] == nil
        podcast_name = item.at_xpath("title").text.scan(/(.+) \d+/)[0][0]
        episode_nr = item.at_xpath("title").text.scan(/\d+/)[0].to_i
        content = ReverseMarkdown.parse item.at_xpath("content:encoded").text
        linkless_content = content.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1').squeeze(' ')
        clean_content = linkless_content.gsub("Download #{podcast_name} #{(episode_nr).to_s.rjust(3, '0')}",'').gsub("Download Podcast (mp3)", '').rstrip
        links = content.scan(/\[([^\]]+)\]\(([^)]+)\)/)
        if Podcast.find_by_name(podcast_name) == nil
          Podcast.create!(:name => podcast_name)
        end
        @ep =  Episode.create!(:podcast => Podcast.find_by_name(podcast_name),
                              :number => episode_nr,
                              :title => item.at_xpath("title").text.scan(/:\D(.+)/)[0][0],
                              :description => clean_content,
                              :file => links.last[1].match(/^[^ ]+/)[0],
                              :created_at => item.at_xpath("pubDate").text)
        links[0..-2].each do |link|
          if link[1].match(/\"(.+)\"/)
            ShowNote.create!(:name => link[1].match(/\"(.+)\"/)[1],
                             :url => link[1].match(/^[^ ]+/)[0],
                             :episode => @ep )
          else
            ShowNote.create!(:name => link[0],
                             :url => link[1],
                             :episode => @ep )
          end
        end
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
      row :author
      row :description
      row :keywords
      row :explicit
      row :category_list
      row :slug
    end
    link_to("New Episode", new_admin_podcast_episode_path(podcast), :class => "member_link")
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :author
      f.input :description
      f.input :keywords
      f.input :explicit
      f.input :category_list, :hint => "Seperated by commas.", :label => "Categories"
      f.input :artwork
      f.input :slug
    end

    f.buttons
  end
end