xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:content" => "http://purl.org/rss/1.0/modules/content/" do
  xml.channel do
    xml.title @podcast.name
    xml.link podcast_url(@podcast)
    xml.description @podcast.description
    if @settings.feed_language.blank?
      xml.language "en-us"
    else
      xml.language @settings.feed_language
    end
    xml.pubDate @episodes.count > 0 ? @episodes.first.created_at.to_s(:rfc822) : @podcast.created_at.to_s(:rfc822)
    xml.lastBuildDate @episodes.count > 0 ? @episodes.first.created_at.to_s(:rfc822) : @podcast.created_at.to_s(:rfc822)
    if @settings.feed_author.blank?
      xml.itunes :author, @settings.site_name
    else
      xml.itunes :author, @settings.feed_author
    end
    xml.itunes :summary, @podcast.description
    xml.itunes :subtitle, @podcast.description
    xml.itunes :keywords, @podcast.keywords
    if @podcast.explicit
      xml.itunes :explicit, 'yes'
    else
      xml.itunes :explicit, 'clean'
    end
    xml.itunes :image, href: "#{root_url}#{@podcast.artwork.url[1..-1]}"
    xml.itunes :owner do
      xml.itunes :name, @podcast.author
      xml.itunes :email, @settings.feed_email
    end
    xml.itunes :block, 'no'

    unless @podcast.category1.blank?
      if @podcast.category1.include? ":"
        xml.itunes :category, text: @podcast.category1.match(/(.*):/)[1] do
          xml.itunes :category, text: @podcast.category1.match(/:(.*)/)[1].strip
          if @podcast.category2.include? ":"
            if @podcast.category1.match(/(.*):/)[1] == @podcast.category2.match(/(.*):/)[1]
              xml.itunes :category, text: @podcast.category2.match(/:(.*)/)[1].strip
            end
          end
          if @podcast.category3.include? ":"
            if @podcast.category1.match(/(.*):/)[1] == @podcast.category3.match(/(.*):/)[1]
              xml.itunes :category, text: @podcast.category3.match(/:(.*)/)[1].strip
            end
          end
        end
      else
        xml.itunes :category, text: @podcast.category1
      end
    end

    unless @podcast.category2.blank?
      if @podcast.category2.include? ":"
        unless @podcast.category2.match(/(.*):/)[1] == @podcast.category1.match(/(.*):/)[1]    
          xml.itunes :category, text: @podcast.category2.match(/(.*):/)[1] do
            xml.itunes :category, text: @podcast.category2.match(/:(.*)/)[1].strip
            if @podcast.category3.include? ":"
              if @podcast.category2.match(/(.*):/)[1] == @podcast.category3.match(/(.*):/)[1]
                xml.itunes :category, text: @podcast.category3.match(/:(.*)/)[1].strip
              end
            end
          end
        end
      else
        xml.itunes :category, text: @podcast.category2
      end
    end

    unless @podcast.category3.blank?
      if @podcast.category3.include? ":"
        unless @podcast.category3.match(/(.*):/)[1] == (@podcast.category1.match(/(.*):/)[1] || @podcast.category2.match(/(.*):/)[1])
          xml.itunes :category, text: @podcast.category3.match(/(.*):/)[1] do
            xml.itunes :category, text: @podcast.category3.match(/:(.*)/)[1].strip
          end
        end
      else
        xml.itunes :category, text: @podcast.category3
      end
    end

    @episodes.each do |episode|
      present episode, EpisodeFeedPresenter do |episode_presenter|
        xml.item do
          xml.title episode_presenter.full_title
          xml.link episode_presenter.uri
          xml.guid episode_presenter.uri
          xml.pubDate episode_presenter.created_at
          xml.description episode_presenter.clean_description
          xml.enclosure url: episode_presenter.file.url, length: episode_presenter.file.size, type: episode_presenter.file_type
          xml.itunes :author, episode_presenter.author
          xml.itunes :duration, episode_presenter.duration
          xml.itunes :subtitle, episode_presenter.truncated_clean_description
          xml.itunes :summary, episode_presenter.clean_description
          xml.itunes :keywords, episode_presenter.keywords
          xml.itunes :image, href: episode_presenter.artwork
          xml.itunes :explicit, episode_presenter.explicit
          xml.tag!("content:encoded") { xml.cdata!(episode_presenter.content) }
        end
      end
    end
  end
end