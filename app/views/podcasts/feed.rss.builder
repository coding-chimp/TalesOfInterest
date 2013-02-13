author = "Tales of Interest"
keywords = "tales, movies music"

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title @podcast.name
    xml.link podcast_url(@podcast)
    xml.description @podcast.description
    xml.language "de"
    xml.pubDate @episodes.first.created_at.to_s(:rfc822)
    xml.lastBuildDate @episodes.first.created_at.to_s(:rfc822)
    xml.itunes :author, author
    xml.itunes :summary, @podcast.description
    xml.itunes :keywords, keywords
    xml.itunes :explicit, 'clean'
    xml.itunes :image, :href => @podcast.artwork
    xml.itunes :owner do
      xml.itunes :name, author
      xml.itunes :email, 'mail@talesofinterest.de'
    end
    xml.itunes :block, 'no'
    xml.itunes :category, :text => 'TV & Film' do
      xml.itunes :category, :text => 'Kp'
    end
    xml.itunes :category, :text => 'Music' do
      xml.itunes :category, :text => 'Kp'
    end

    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.link episode_url(@podcast, episode)
        xml.guid episode_url(@podcast, episode)
        xml.pubDate episode.created_at.to_s(:rfc822)
        xml.description episode.description
        xml.enclosure :url => episode.file, :length => episode.file_size, :type => 'audio/x-m4a'
        xml.content :encoded, raw("<p>#{episode.description}</p>
" + episode.stringify_show_notes)
        xml.itunes :author, author
        xml.itunes :duration, episode.playtime
        xml.itunes :subtitle, truncate(episode.description, :length => 150)
        xml.itunes :summary, episode.description
        xml.itunes :keywords, keywords
        xml.itunes :image, :href => @podcast.artwork
        if episode.explicit
            xml.itunes :explicit, 'yes'
        else
            xml.itunes :explicit, 'no'
        end 
      end
    end
  end
end