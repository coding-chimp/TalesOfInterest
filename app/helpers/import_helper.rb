module ImportHelper
  def import_episodes(file)
    xml = Nokogiri::XML(file)
  	items = xml.xpath("//channel//item")
  	author = xml.at_xpath("//channel//title").text
  	items.each do |item|
  	  unless item.at_xpath("title").text.scan(/(.+) \d+/)[0] == nil
  	    podcast_name = item.at_xpath("title").text.scan(/(.+) \d+/)[0][0]
  	    episode_nr = item.at_xpath("title").text.scan(/\d+/)[0].to_i
  	    content = ReverseMarkdown.parse item.at_xpath("content:encoded").text
  	    links = content.scan(/\[([^\]]+)\]\(([^)]+)\)/)
  	    content = content.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1').squeeze(' ')
  	    content = content.gsub("Download #{podcast_name} #{(episode_nr).to_s.rjust(3, '0')}",'').gsub("	Download   Podcast (mp3)", '').rstrip   
  	    if Podcast.find_by_name(podcast_name) == nil
  	      Podcast.create!(:name => podcast_name, :author => author)
  	    end
  	    @ep =  Episode.create!(:podcast => Podcast.find_by_name(podcast_name),
  	                           :number => episode_nr,
  	                           :title => item.at_xpath("title").text.scan(/:\D(.+)/)[0][0],
  	                           :description => content,
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
	end
end