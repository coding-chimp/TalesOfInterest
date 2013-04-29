module ImportHelper
  def import_episodes(file)
    xml = Nokogiri::XML(file)
  	items = xml.xpath("//channel//item")
  	author = xml.at_xpath("//channel//title").text
  	items.each do |item|
  	  unless item.at_xpath("title").text.scan(/(.+) \d+:/)[0] == nil
  	    podcast_name = item.at_xpath("title").text.scan(/(.+) \d+:/)[0][0]
  	    episode_nr = item.at_xpath("title").text.scan(/(\d+):/)[0][0].to_i
        content = HTMLPage.new :contents => item.at_xpath("content:encoded").text
  	    description = content.markdown
        links = description.scan(/\[([^\]]+)\]\(([^)]+)\)/)
  	    description = description.gsub("Download #{podcast_name} #{episode_nr.to_s.rjust(3, '0')}",'').gsub("Download Podcast (mp3)",'').gsub(/\[\]\(.*\)/,'')
  	    if Podcast.find_by_name(podcast_name) == nil
  	      Podcast.create!(:name => podcast_name, :author => author)
  	    end
  	    @ep =  Episode.create!(:podcast => Podcast.find_by_name(podcast_name),
  	                           :number => episode_nr,
  	                           :title => item.at_xpath("title").text.scan(/:\D(.+)/)[0][0],
  	                           :description => description,
  	                           :file => links.last[1].match(/^[^ ]+/)[0],
                               :draft => true,
  	                           :created_at => item.at_xpath("pubDate").text,
                               :published_at => item.at_xpath("pubDate").text)
  	  end
  	end
	end

  def import_pages(file)
    items = Nokogiri::XML(params[:import][:file]).xpath("//channel//item")
    items.each do |item|
      text = HTMLPage.new :contents => item.at_xpath("content:encoded").text
      Page.create!( :title => item.at_xpath("title").text,
                    :content =>  text.markdown )
    end
  end
end