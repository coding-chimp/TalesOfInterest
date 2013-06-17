module ImportHelper
  def import_episodes(file)
    xml = Nokogiri::XML(file)
  	items = xml.xpath("//channel//item")
  	author = xml.at_xpath("//channel//title").text
  	items.each do |item|
      podcast_name = item.at_xpath("title").text.scan(/(.+) \d+:/)[0][0]
      next if podcast_name.nil?
      podcast = find_podcast(podcast_name, author)
      parse_episode(item, podcast) 
  	end
	end

  def import_pages(file)
    items = Nokogiri::XML(params[:import][:file]).xpath("//channel//item")
    items.each do |item|
      text = HTMLPage.new :contents => item.at_xpath("content:encoded").text
      Page.create!(title: item.at_xpath("title").text, content:  text.markdown )
    end
  end

  private

  def find_podcast(name, author)
    Podcast.find_by_name(name) || Podcast.create!(name: name, author: author)
  end

  def parse_episode(item, podcast)
    title = item.at_xpath("title").text.scan(/:\D(.+)/)[0][0]
    episode_nr = item.at_xpath("title").text.scan(/(\d+):/)[0][0].to_i
    pub_date = item.at_xpath("pubDate").text
    description = HTMLPage.new :contents => item.at_xpath("content:encoded").text
    description = description.markdown
    file = description.scan(/\[([^\]]+)\]\(([^)]+)\)/).last[1].match(/^[^ ]+/)[0]
    description = description.gsub("Download #{podcast_name} #{episode_nr.to_s.rjust(3, '0')}",'').gsub("Download Podcast (mp3)",'').gsub(/\[\]\(.*\)/,'')
    Episode.create!(podcast: podcast, number: episode_nr, title: title, description: description,
                    file: file, draft: true, created_at: pub_date, published_at: pub_date)
  end
end