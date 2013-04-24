xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
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
    xml.itunes :image, href: @podcast.artwork
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
      xml.item do
        xml.title "#{@podcast.name} #{episode.num}: #{episode.title}"
        xml.link episode_url(@podcast, episode)
        xml.guid({isPermalink: "false"}, episode_url(@podcast, episode))
        xml.pubDate episode.created_at.to_s(:rfc822)
        xml.description episode.description
        xml.enclosure url: episode.file, length: episode.file_size, type: 'audio/x-m4a'
        xml.content :encoded, raw("<p>#{episode.description}</p>\n" + episode.stringify_show_notes)
        xml.itunes :author, @podcast.author
        xml.itunes :duration, episode.feed_duration
        xml.itunes :subtitle, truncate(episode.description, length: 150)
        xml.itunes :summary, episode.description
        xml.itunes :keywords, @podcast.keywords
        xml.itunes :image, href: @podcast.artwork
        if episode.explicit
          xml.itunes :explicit, 'yes'
        else
          xml.itunes :explicit, 'no'
        end
      end
    end
  end
end